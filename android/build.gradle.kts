allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// share_plus 13.3.0 skips applying the Kotlin Android plugin on AGP 9+ but still
// configures KotlinAndroidProjectExtension, so apply it for that module.
subprojects {
    if (name == "share_plus") {
        pluginManager.withPlugin("com.android.library") {
            if (!pluginManager.hasPlugin("org.jetbrains.kotlin.android")) {
                pluginManager.apply("org.jetbrains.kotlin.android")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
