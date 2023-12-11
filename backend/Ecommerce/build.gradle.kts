val ktorVersion: String by project
val kotlinVersion: String by project
val logbackVersion: String by project
val kmongoVersion: String by project
val koinVersion: String by project
val koinKtorVersion: String by project

plugins {
    kotlin("jvm") version "1.9.10"
    id("io.ktor.plugin") version "2.3.3"
    id("org.jetbrains.kotlin.plugin.serialization") version "1.9.10"
}

group = "com.ahmedhnewa"
version = "0.0.1"
application {
//    mainClass.set("io.ktor.server.netty.EngineMain")
    mainClass.set("com.ahmedhnewa.ApplicationKt")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
//    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=true")

}

repositories {
    mavenCentral()
    google()
}

val javaVersion: JavaVersion = JavaVersion.VERSION_17

tasks.withType<JavaCompile> {
    sourceCompatibility = javaVersion.toString()
    targetCompatibility = javaVersion.toString()
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions.jvmTarget = javaVersion.toString()
}

val sshAntTask: Configuration = configurations.create("sshAntTask")

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-host-common-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-call-logging-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation-jvm:$ktorVersion")
    implementation("io.ktor:ktor-serialization-kotlinx-json-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-websockets-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-default-headers-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-cors-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-compression-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-caching-headers-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-status-pages-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-http-redirect-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-sessions-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-auth-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-auth-jwt-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-netty-jvm:$ktorVersion")
    implementation("ch.qos.logback:logback-classic:$logbackVersion")
    testImplementation("io.ktor:ktor-server-tests-jvm:$ktorVersion")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlinVersion")
    implementation("io.ktor:ktor-server-rate-limit:$ktorVersion")
    implementation("io.ktor:ktor-server-html-builder:$ktorVersion")
    implementation("io.ktor:ktor-server-resources:$ktorVersion")

    implementation("io.ktor:ktor-client-core:$ktorVersion")
    implementation("io.ktor:ktor-client-cio:$ktorVersion")
    implementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
    implementation("io.ktor:ktor-client-logging:$ktorVersion")
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")

    implementation("io.github.cdimascio:dotenv-kotlin:6.4.1")

//    implementation("com.sun.mail:javax.mail:1.6.2")
    implementation("com.sun.mail:jakarta.mail:2.0.1")

    implementation("org.litote.kmongo:kmongo:$kmongoVersion")
    implementation("org.litote.kmongo:kmongo-coroutine:$kmongoVersion")
    implementation("commons-codec:commons-codec:1.15")

    implementation("io.insert-koin:koin-core:$koinVersion")
    implementation("io.insert-koin:koin-ktor:$koinKtorVersion")
    implementation("io.insert-koin:koin-logger-slf4j:$koinKtorVersion")
//    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.4.1")
//    implementation("com.google.api-client:google-api-client:1.33.0")
//    implementation("com.google.cloud:google-cloud-storage:2.4.0")
    implementation("com.google.auth:google-auth-library-oauth2-http:1.3.0") // for Firebase auth
    implementation("com.google.api-client:google-api-client:2.2.0") // for Google sign in

    implementation("com.auth0:jwks-rsa:0.22.0")

    sshAntTask("org.apache.ant:ant-jsch:1.10.13")
}

val buildingJarFileName = "temp-server.jar"
val startingJarFileName = "server.jar"

val serverUser = "root"
val serverHost = "193.23.160.48"
val serverSshKey = file("keys/id_rsa")
val deleteLog = true
val lockFileName = ".serverLock"

val serviceName = "ktor-server"
val serverFolderName = "app"

ktor {
    fatJar {
        archiveFileName.set(buildingJarFileName)
    }
}

ant.withGroovyBuilder {
    "taskdef"(
        "name" to "scp",
        "classname" to "org.apache.tools.ant.taskdefs.optional.ssh.Scp",
        "classpath" to configurations["sshAntTask"].asPath
    )
    "taskdef"(
        "name" to "ssh",
        "classname" to "org.apache.tools.ant.taskdefs.optional.ssh.SSHExec",
        "classpath" to configurations["sshAntTask"].asPath
    )
}

fun sudoIfNeeded(): String {
    if (serverUser.trim() == "root") {
        return ""
    }
    return "sudo "
}

fun runSshCommand(command: String, knownHosts: File) = ant.withGroovyBuilder {
    "ssh"(
        "host" to serverHost,
        "username" to serverUser,
        "keyfile" to serverSshKey,
        "trust" to true,
        "knownhosts" to knownHosts,
        "command" to command
    )
}

task("cleanAndDeploy") {
    dependsOn("clean", "deploy")
}

task("deploy") {
    dependsOn("buildFatJar")
    ant.withGroovyBuilder {
        doLast {
            val knownHosts = File.createTempFile("knownhosts", "txt")
            try {
                println("Make sure the $serverFolderName folder exists if doesn't")
                runSshCommand(
                    "mkdir -p \$HOME/$serverFolderName",
                    knownHosts
                )
                println("Lock the server requests...")
                runSshCommand(
                    "touch \$HOME/$serverFolderName/$lockFileName",
                    knownHosts
                )
                println("Deleting the previous building jar file if exists...")
                runSshCommand(
                    "rm \$HOME/$serverFolderName/$buildingJarFileName -f",
                    knownHosts
                )
                println("Uploading the new jar file...")
                val file = file("build/libs/$buildingJarFileName")
                "scp"(
                    "file" to file,
                    "todir" to "$serverUser@$serverHost:/\$HOME/$serverFolderName",
                    "keyfile" to serverSshKey,
                    "trust" to true,
                    "knownhosts" to knownHosts
                )
                println("Upload done, attempt to stop the current ktor server...")
                runSshCommand(
                    "${sudoIfNeeded()}systemctl stop $serviceName",
                    knownHosts
                )
                println("Server stopped, attempt to delete the current ktor server jar...")
                runSshCommand(
                    "rm \$HOME/$serverFolderName/$startingJarFileName -f",
                    knownHosts,
                )
                println("The old ktor server jar file has been deleted, now let's rename the new jar file")
                runSshCommand(
                    "mv \$HOME/$serverFolderName/$buildingJarFileName \$HOME/$serverFolderName/$startingJarFileName",
                    knownHosts
                )
                if (deleteLog) {
                    runSshCommand(
                        "rm /var/log/$serviceName.log -f",
                        knownHosts
                    )
                    println("The $serviceName log at /var/log/$serviceName.log has been removed")
                }
                println("Unlock the server requests...")
                runSshCommand(
                    "rm \$HOME/$serverFolderName/$lockFileName -f",
                    knownHosts
                )
                println("Now let's start the ktor server service!")
                runSshCommand(
                    "${sudoIfNeeded()}systemctl start $serviceName",
                    knownHosts
                )
                println("Done!")
            } catch (e: Exception) {
                println("Error: ${e.message}")
            } finally {
                knownHosts.delete()
            }
        }
    }
}

task("upgrade") {
    ant.withGroovyBuilder {
        doLast {
            val knownHosts = File.createTempFile("knownhosts", "txt")
            try {
                println("Update repositories...")
                runSshCommand(
                    "${sudoIfNeeded()}apt update",
                    knownHosts
                )
                println("Update packages...")
                runSshCommand(
                    "${sudoIfNeeded()}apt upgrade -y",
                    knownHosts
                )
                println("Done")
            } catch (e: Exception) {
                println("Error while upgrading server packages: ${e.message}")
            } finally {
                knownHosts.delete()
            }
        }
    }
}

abstract class ProjectNameTask : DefaultTask() {

    @TaskAction
    fun greet() = println("The project name is ${project.name}")
}

tasks.register<ProjectNameTask>("projectName")

tasks {
    create("stage").dependsOn("installDist")
}
