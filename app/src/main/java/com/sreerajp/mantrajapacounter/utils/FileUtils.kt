package com.sreerajp.mantrajapacounter.utils

import android.content.Context
//import android.content.Intent
import android.net.Uri
//import androidx.activity.result.ActivityResultLauncher
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.sreerajp.mantrajapacounter.data.ExportData
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.text.SimpleDateFormat
import java.util.*

/**
 * Utility object for JSON export/import and ContentResolver-based file I/O operations
 * Provides methods to serialize/deserialize counter data and read/write files via content URIs
 *
 * Features:
 * - JSON serialization/deserialization for export data
 * - File read/write operations using Android content providers
 * - Error handling and graceful failure recovery
 */
object FileUtils {
    // ===== GSON CONFIGURATION =====
    // Gson instance configured for pretty-printing JSON output
    private val gson: Gson = GsonBuilder()
        .setPrettyPrinting()
        .create()

    /**
     * Generates a timestamped filename for export backup files
     * Format: mantrajapa_backup_yyyy-MM-dd_HH-mm-ss.json
     *
     * @return Timestamped filename string
     */
    fun createExportFilename(): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault())
        val timestamp = dateFormat.format(Date())
        return "mantrajapa_backup_$timestamp.json"
    }

    /**
     * Serializes export data to pretty-printed JSON string
     * @param exportData The export data to serialize
     * @return JSON string representation of the export data
     */
    fun exportDataToJson(exportData: ExportData): String {
        return gson.toJson(exportData)
    }

    /**
     * Parses JSON string into ExportData object
     * @param jsonString The JSON string to parse
     * @return ExportData object if parsing succeeds, null if an error occurs
     */
    fun importDataFromJson(jsonString: String): ExportData? {
        return try {
            gson.fromJson(jsonString, ExportData::class.java)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    /**
     * Writes content to a file specified by URI using ContentResolver
     * Creates or overwrites the file at the given URI
     *
     * @param context Android application context
     * @param uri URI of the file to write to (usually from file picker)
     * @param content String content to write
     * @return true if write succeeded, false if an error occurred
     */
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

    /**
     * Reads all text content from a file specified by URI using ContentResolver
     * @param context Android application context
     * @param uri URI of the file to read from (usually from file picker)
     * @return String content of the file, or null if an error occurs
     */
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
