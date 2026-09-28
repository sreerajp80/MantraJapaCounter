package com.sreerajp.mantrajapacounter

import com.google.zxing.BarcodeFormat
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.LuminanceSource
import com.google.zxing.NotFoundException
import com.google.zxing.PlanarYUVLuminanceSource
import com.google.zxing.ReaderException
import com.google.zxing.common.HybridBinarizer
import com.google.zxing.qrcode.QRCodeReader

/**
 * Reads a QR code from one camera frame, fully on the device.
 *
 * Uses the ZXing core library: plain Java maths (finder patterns, grid
 * sampling, Reed-Solomon error correction). No network, no Play Services.
 *
 * The input is the brightness ("Y") plane of a YUV camera frame. [rowStride]
 * is the number of bytes per row, which can be larger than [width] because of
 * padding at the end of each row.
 *
 * Every frame gets a fast search. Every [slowSearchEvery]th frame that the
 * fast search misses also gets a slow, thorough search (TRY_HARDER plus the
 * inverted image). Calls come from one thread only, so the counter is safe.
 */
object QrFrameDecoder {
    private const val slowSearchEvery = 4

    private val fastHints: Map<DecodeHintType, Any> = mapOf(
        DecodeHintType.POSSIBLE_FORMATS to listOf(BarcodeFormat.QR_CODE),
        DecodeHintType.CHARACTER_SET to "UTF-8",
    )

    // Slower per frame, but finds codes that are small, tilted or soft.
    private val slowHints: Map<DecodeHintType, Any> = fastHints + mapOf(
        DecodeHintType.TRY_HARDER to true,
    )

    private var missesSinceSlowSearch = 0

    /**
     * Returns the QR text, or null when no QR code is found.
     *
     * Only the crop rectangle ([cropLeft], [cropTop], [cropWidth],
     * [cropHeight]) is searched; by default that is the whole frame.
     */
    fun decode(
        bytes: ByteArray,
        width: Int,
        height: Int,
        rowStride: Int,
        cropLeft: Int = 0,
        cropTop: Int = 0,
        cropWidth: Int = width,
        cropHeight: Int = height,
    ): String? {
        require(width > 0 && height > 0) { "width and height must be positive" }
        require(rowStride >= width) { "rowStride must be at least width" }
        require(bytes.size >= rowStride * (height - 1) + width) { "frame is too small" }
        require(cropLeft >= 0 && cropTop >= 0 && cropWidth > 0 && cropHeight > 0) {
            "crop must be inside the frame"
        }
        require(cropLeft + cropWidth <= width && cropTop + cropHeight <= height) {
            "crop must be inside the frame"
        }

        val source = PlanarYUVLuminanceSource(
            bytes, rowStride, height, cropLeft, cropTop, cropWidth, cropHeight, false,
        )

        decodeSource(source, fastHints)?.let {
            missesSinceSlowSearch = 0
            return it
        }

        missesSinceSlowSearch++
        if (missesSinceSlowSearch < slowSearchEvery) return null
        missesSinceSlowSearch = 0
        // Try the normal image first, then the inverted one, so light codes
        // on a dark background are read too.
        return decodeSource(source, slowHints) ?: decodeSource(source.invert(), slowHints)
    }

    private fun decodeSource(source: LuminanceSource, hints: Map<DecodeHintType, Any>): String? {
        val reader = QRCodeReader()
        return try {
            reader.decode(BinaryBitmap(HybridBinarizer(source)), hints).text
        } catch (e: NotFoundException) {
            null
        } catch (e: ReaderException) {
            // Checksum or format errors: a blurred or partial code. The next
            // frame usually reads cleanly.
            null
        } finally {
            reader.reset()
        }
    }
}
