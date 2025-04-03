return {
    "chrisgrieser/nvim-chainsaw",
    config = function()
        require("chainsaw").setup {
            marker = "🪚",
            beepEmojis = { "🔵", "🟩", "⭐", "⭕", "💜", "🔲" },
        }
    end
}
