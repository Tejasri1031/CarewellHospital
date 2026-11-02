
package com.util;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

public class FileStorageUtil {

    private static final String STORAGE_DIRECTORY =
            System.getenv().getOrDefault(
                    "CAREWELL_UPLOAD_DIR",
                    "medical-uploads"
            );

    private static final Set<String> ALLOWED_EXTENSIONS =
            Set.of(".pdf", ".jpg", ".jpeg", ".png");

    public static String saveFile(
            InputStream inputStream,
            String extension) throws IOException {

        if (inputStream == null
                || extension == null
                || !ALLOWED_EXTENSIONS.contains(
                        extension.toLowerCase(Locale.ROOT))) {

            throw new IOException(
                    "Invalid file or unsupported extension."
            );
        }

        Path directory = Paths.get(STORAGE_DIRECTORY)
                .toAbsolutePath()
                .normalize();

        Files.createDirectories(directory);

        String storageKey = UUID.randomUUID().toString()
                + extension.toLowerCase(Locale.ROOT);

        Path destination = directory.resolve(storageKey)
                .normalize();

        if (!destination.getParent().equals(directory)) {
            throw new IOException("Invalid storage path.");
        }

        // UUID-based names avoid overwriting existing files.
        Files.copy(inputStream, destination);
        System.out.println("MEDICAL FILE SAVED AT: "
                + destination.toAbsolutePath());

        return storageKey;
    }

    public static void deleteFile(String storageKey)
            throws IOException {

        if (storageKey == null || storageKey.isBlank()) {
            throw new IOException("Invalid storage key.");
        }

        Path directory = Paths.get(STORAGE_DIRECTORY)
                .toAbsolutePath()
                .normalize();

        Path file = directory.resolve(storageKey)
                .normalize();

        if (!file.getParent().equals(directory)) {
            throw new IOException("Invalid storage key.");
        }

        Files.deleteIfExists(file);
    }
    
    public static Path getFilePath(String storageKey) throws IOException {

        if (storageKey == null
                || storageKey.isBlank()
                || storageKey.contains("/")
                || storageKey.contains("\\")
                || storageKey.contains("..")) {
            throw new IOException("Invalid storage key.");
        }

        Path directory = Paths.get(STORAGE_DIRECTORY)
                .toAbsolutePath()
                .normalize();

        Path file = directory.resolve(storageKey).normalize();

        if (!file.getParent().equals(directory)) {
            throw new IOException("Invalid storage key.");
        }

        if (!Files.exists(file) || !Files.isRegularFile(file)) {
            throw new IOException("Medical document not found.");
        }

        Path realDirectory = directory.toRealPath();
        Path realFile = file.toRealPath();

        if (!realFile.startsWith(realDirectory)
                || !Files.isRegularFile(realFile)) {
            throw new IOException("Invalid medical document path.");
        }

        return realFile;
    }
}
