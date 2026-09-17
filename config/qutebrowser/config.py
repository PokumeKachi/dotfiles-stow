# qutebrowser configuration
# Keyboard-first, minimal, Wayland/Niri-friendly setup.

config.load_autoconfig(False)


# ─────────────────────────────────────────────────────────────────────────────
# General
# ─────────────────────────────────────────────────────────────────────────────

# Restore tabs/windows after qutebrowser exits or crashes.
c.auto_save.session = True

# Start with a blank page rather than loading a homepage.
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# Don't automatically search when a URL is mistyped.
c.url.open_base_url = True

# Search engine.
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
    "cf": "https://codeforces.com/search?query={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "r": "https://www.reddit.com/search/?q={}",
}


# ─────────────────────────────────────────────────────────────────────────────
# Editor
# ─────────────────────────────────────────────────────────────────────────────

# Use Neovim instead of gVim for <Ctrl-E> / external editing.
#
# qutebrowser writes the editable text to a temporary file and replaces
# {file} with its path.
c.editor.command = ["kitty", "--", "nvim", "{file}"]


# ─────────────────────────────────────────────────────────────────────────────
# Tabs
# ─────────────────────────────────────────────────────────────────────────────

# Open links in new tabs instead of replacing the current page.
c.tabs.background = True

# Keep the tab bar visible.
c.tabs.show = "multiple"

# Put new tabs next to the current tab.
c.tabs.new_position.related = "next"

# Don't automatically select newly opened background tabs.
c.tabs.select_on_remove = "last-used"

# Wrap tab navigation.
c.tabs.wrap = True


# ─────────────────────────────────────────────────────────────────────────────
# Downloads
# ─────────────────────────────────────────────────────────────────────────────

c.downloads.location.directory = "~/media/downloads"

# Ask where to save files instead of silently dumping everything into Downloads.
c.downloads.location.prompt = True

# Remove completed downloads from qutebrowser's download list.
c.downloads.remove_finished = 5000


# ─────────────────────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────────────────────

# Keep completion useful without making it huge.
c.completion.height = "40%"
c.completion.shrink = True

# Show history and bookmarks when starting completion.
c.completion.web_history.max_items = 10000


# ─────────────────────────────────────────────────────────────────────────────
# Scrolling
# ─────────────────────────────────────────────────────────────────────────────

# Comfortable keyboard scrolling.
c.scrolling.smooth = True

# Number of pixels moved by j/k.
c.scrolling.bar = "when-searching"


# ─────────────────────────────────────────────────────────────────────────────
# Fonts
# ─────────────────────────────────────────────────────────────────────────────

# Keep the UI compact.
c.fonts.default_family = "sans-serif"
c.fonts.default_size = "10pt"

c.fonts.completion.entry = "10pt sans-serif"
c.fonts.completion.category = "bold 10pt sans-serif"
c.fonts.statusbar = "10pt sans-serif"
c.fonts.tabs.selected = "10pt sans-serif"
c.fonts.tabs.unselected = "10pt sans-serif"


# ─────────────────────────────────────────────────────────────────────────────
# Privacy
# ─────────────────────────────────────────────────────────────────────────────

# Don't retain unnecessary session history indefinitely.
c.history_gap_interval = 30

# Prefer HTTPS when possible.
c.content.tls.certificate_errors = "ask"

# Disable JavaScript notifications.
c.content.notifications.enabled = False

# Don't allow websites to access your clipboard automatically.
c.content.javascript.clipboard = "access"

# Block websites from requesting fullscreen without interaction.
c.content.fullscreen.window = False


# ─────────────────────────────────────────────────────────────────────────────
# Content
# ─────────────────────────────────────────────────────────────────────────────

# JavaScript is required by many sites, especially university services,
# GitHub, Codeforces, etc., so leave it enabled.
c.content.javascript.enabled = True

# Allow autoplay only when explicitly initiated.
c.content.autoplay = False

# Block unsolicited geolocation requests.
c.content.geolocation = False

# Camera/microphone requests should require explicit permission.
c.content.media.audio_capture = "ask"
c.content.media.video_capture = "ask"


# ─────────────────────────────────────────────────────────────────────────────
# Completion / hints
# ─────────────────────────────────────────────────────────────────────────────

# Vim-like hint appearance.
c.hints.radius = 0
c.hints.min_chars = 1

# Use the keyboard layout naturally.
c.bindings.key_mappings = {
    "<Ctrl-[>": "<Escape>",
}


# ─────────────────────────────────────────────────────────────────────────────
# Status bar
# ─────────────────────────────────────────────────────────────────────────────

# Keep the status bar simple.
c.statusbar.show = "in-mode"


# ─────────────────────────────────────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────────────────────────────────────

# Let websites determine their own colors.
# qutebrowser's default theme remains responsible for the UI.


# ─────────────────────────────────────────────────────────────────────────────
# Useful keyboard shortcuts
# ─────────────────────────────────────────────────────────────────────────────

config.bind(",r", "reload")
config.bind(",R", "reload -f")

# Duplicate current tab.
config.bind(",t", "tab-clone")

# Close all other tabs.
config.bind(",o", "tab-only")

# Quick access to common development sites.
config.bind(",g", "open https://github.com")
config.bind(",c", "open https://codeforces.com")
config.bind(",h", "open https://hcmus.edu.vn")

# Clear temporary site data for the current website.
config.bind(",C", "clear-messages")


# ─────────────────────────────────────────────────────────────────────────────
# Domain-specific settings
# ─────────────────────────────────────────────────────────────────────────────

# Codeforces
config.set("content.javascript.enabled", True, "https://codeforces.com/*")

# GitHub
config.set("content.javascript.enabled", True, "https://github.com/*")

# HCMUS
config.set("content.javascript.enabled", True, "https://*.hcmus.edu.vn/*")
