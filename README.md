# CleverNote
An app demonstrating the `UIDocumentPickerExtension`

SETUP

1. For each target, in the Capabilities tab: enable app-groups for all three targets, set them all as the same app group.
2. In Note.swift change `appGroupIdentifier` to that new group ID
3. In the Info.plist for Clever `NoteFileProvider`: update `NSExtensionFileProviderDocumentGroup` to that new group id
