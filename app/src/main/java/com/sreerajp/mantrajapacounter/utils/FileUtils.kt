package com.sreerajp.mantrajapacounter.utils

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.activity.result.ActivityResultLauncher
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.sreerajp.mantrajapacounter.data.ExportData
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.text.SimpleDateFormat
import java.util.*

object FileUtils {
    private val gson: Gson = GsonBuilder()
        .setPrettyPrinting()
        .create()

    fun createExportFilename(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault())
        val timestamp = dateFormat.format(Date())
        return "mantrajapa_backup_$timestamp.json"
    }

    fun exportDataToJson(exportData: ExportData): String {
        return gson.toJson(exportData)
    }

    fun importDataFromJson(jsonString: String): ExportData? {
        return try {
            gson.fromJson(jsonString, ExportData::class.java)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    fun writeToUri(context: Context, uri: Uri, content: String): Boolean {
        return try {
            context.contentResolver.openOutputStream(uri)?.use { outputStream ->
                OutputStreamWriter(outputStream).use { writer ->
                    writer.write(content)
                    writer.flush()
                }
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    fun readFromUri(context: Context, uri: Uri): String? {
        return try {
            context.contentResolver.openInputStream(uri)?.use { inputStream ->
                BufferedReader(InputStreamReader(inputStream)).use { reader ->
                    reader.readText()
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}
