local system = require("utils.system")

return {
    "xuhdev/vim-latex-live-preview",
    cond = function()
        local has_engine = system.executable("pdflatex") or system.executable("xelatex")
        local has_viewer = system.executable("evince") or system.executable("okular")
        return has_engine and has_viewer
    end,
}
