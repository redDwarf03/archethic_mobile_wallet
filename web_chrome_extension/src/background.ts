chrome.runtime.onMessageExternal.addListener((message, sender, sendResponse) => {
    if (message === 'ensureExtensionPopupOpened') {
        ensureExtensionPopupOpened().then(() => { sendResponse() })
        return true
    }
})

chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message === 'areMultipleExtensionPopupsOpened') {
        areMultipleExtensionPopupsOpened().then((response) => {
            sendResponse(response)
        })
        return true
    }
    if (message === 'focusExtensionPopup') {
        focusExtensionPopup().then((response) => {
            sendResponse(response)
        })
        return true
    }
    if (message.type === "updateIcon" && typeof message.isLocked === "boolean") {
        const isLocked = message.isLocked;
        updateExtensionIcon(isLocked);
        return false;
    }
})

chrome.action.onClicked.addListener(async function (_) {
    await openExtensionPopup()
});


function extensionUrl(): string {
    return `chrome-extension://${chrome.runtime.id}/index.html`
}

/**
 * @returns {boolean} true if a extension popup has been focused
 */
async function focusExtensionPopup(): Promise<boolean> {
    const extensionTab = await findExtensionTab()
    if (extensionTab !== null) {
        await chrome.windows.update(
            extensionTab.windowId,
            { focused: true },
        )
        if (extensionTab.id !== undefined) {
            await chrome.tabs.update(
                extensionTab.id,
                { active: true },
            )
        }
        return true
    }
    return false
}

chrome.windows.onRemoved.addListener(async (windowId) => {
    const currentWindowId = await readWindowId()
    if (windowId === currentWindowId) {
        updateExtensionIcon(true)
    }
})

async function findExtensionTab(): Promise<chrome.tabs.Tab | null> {
    const extensionTabs = await chrome.tabs.query({ url: extensionUrl() })

    if (extensionTabs.length === 0) return null
    return extensionTabs[0]
}

async function openExtensionPopup(): Promise<void> {
    if (await focusExtensionPopup()) {
        return
    }

    const currentWindow = await chrome.windows.getCurrent();

    const popupWidth = 370
    const popupHeight = 800

    const left = Math.round((currentWindow.left ?? 200) + (currentWindow.width ?? 0) - popupWidth - 32);
    const top = Math.round((currentWindow.top ?? 200) + 64);

    const window = await chrome.windows.create({
        url: "index.html",
        width: popupWidth,
        height: popupHeight,
        type: "panel",
        focused: true,
        left: left,
        top: top,
    })
    await saveWindowId(window.id!);
}

async function saveWindowId(windowId: number) {
    await chrome.storage.local.set({ extensionWindowId: windowId });
}
async function readWindowId(): Promise<number | null> {
    const values = await chrome.storage.local.get(["extensionWindowId"]);
    return values.extensionWindowId
}

async function isExtensionPopupOpened(): Promise<boolean> {
    return (await findExtensionTab()) !== null
}

async function areMultipleExtensionPopupsOpened(): Promise<boolean> {
    const extensionTabs = await chrome.tabs.query({ url: extensionUrl() })
    return extensionTabs.length > 1
}

async function ensureExtensionPopupOpened() {
    if (await isExtensionPopupOpened()) {
        return
    }
    await openExtensionPopup()
}
async function updateExtensionIcon(isLocked: boolean): Promise<void> {
    const iconPath = isLocked
        ? {
            "16": "icons/icon_16_locked.png",
            "32": "icons/icon_32_locked.png",
            "48": "icons/icon_48_locked.png",
            "128": "icons/icon_128_locked.png"
        }
        : {
            "16": "icons/icon_16.png",
            "32": "icons/icon_32.png",
            "48": "icons/icon_48.png",
            "128": "icons/icon_128.png"
        };

    await chrome.action.setIcon({ path: iconPath });
}
