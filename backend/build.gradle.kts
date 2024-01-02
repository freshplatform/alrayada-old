val kotlinVersion: String = libs.versions.kotlin.get()
val ktorVersion: String = libs.versions.kotlin.get()
val logbackVersion: String = libs.versions.logback.get()
val kmongoVersion: String = libs.versions.kmongo.get()
val koinVersion: String = libs.versions.koin.get()
val koinKtorVersion: String = libs.versions.koinKtor.get()

plugins {
    kotlin("jvm") version libs.versions.kotlin.get()
    id("io.ktor.plugin") version libs.versions.ktor.get()
    id("org.jetbrains.kotlin.plugin.serialization") version libs.versions.kotlin.get()
}

group = "net.freshplatform"
version = "0.0.1"
application {
    mainClass.set("net.freshplatform.ApplicationKt")

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

ktor {
    fatJar {
        archiveFileName.set("app.jar")
    }
}

abstract class ProjectNameTask : DefaultTask() {

    @TaskAction
    fun printProjectName() = println("The project name is ${project.name}")
}

tasks.register<ProjectNameTask>("projectName")

tasks {
    create("stage").dependsOn("installDist")
}
