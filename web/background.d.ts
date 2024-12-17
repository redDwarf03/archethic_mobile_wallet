/// <reference types="chrome" />
declare function extensionUrl(): string;
declare function focusExtensionPopup(): Promise<boolean>;
declare function findExtensionTab(): Promise<chrome.tabs.Tab | null>;
declare function openExtensionPopup(): Promise<void>;
declare function isExtensionPopupOpened(): Promise<boolean>;
declare function areMultipleExtensionPopupsOpened(): Promise<boolean>;
declare function ensureExtensionPopupOpened(): Promise<void>;
declare function updateExtensionIcon(isLocked: boolean): Promise<void>;
