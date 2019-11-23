class Plugin(object):

    def __init__(self, uri, rev='master', patch=False):
        """TODO: to be defined.

        :uri: '{user}/{name}'
        :rev: TODO

        """
        self.uri = uri
        self.rev = rev


# TODO: 测试信息的准确性
# TODO: 当user不同, repo name相同时, 镜像到zgpio仓库中如何解决name冲突.
# TODO: 一些仓库默认不是master分支
mirror_list = [
    Plugin('andymass/vim-matchup'),
    Plugin('cespare/vim-toml'),
    Plugin('easymotion/vim-easymotion'),
    Plugin('gcmt/wildfire.vim'),
    Plugin('godlygeek/tabular'),
    Plugin('hynek/vim-python-pep8-indent'),
    Plugin('honza/vim-snippets'),
    Plugin('iamcco/markdown-preview.nvim'),
    Plugin('jiangmiao/auto-pairs'),
    Plugin('joshdick/onedark.vim'),
    Plugin('kshenoy/vim-signature'),
    Plugin('kristijanhusak/defx-git'),
    Plugin('kristijanhusak/defx-icons'),
    Plugin('kana/vim-operator-user'),
    Plugin('kana/vim-smartchr'),
    Plugin('ludovicchabant/vim-gutentags'),
    Plugin('luochen1990/rainbow'),
    Plugin('lervag/vimtex'),
    Plugin('mhinz/vim-startify'),
    Plugin('mhinz/vim-grepper'),
    Plugin('mhinz/vim-signify'),
    Plugin('morhetz/gruvbox'),
    Plugin('neomake/neomake'),
    Plugin('neoclide/coc.nvim', rev='release'),
    Plugin('numirias/semshi'),
    Plugin('norcalli/nvim-colorizer.lua'),
    Plugin('plasticboy/vim-markdown', patch=True),
    Plugin('pseewald/vim-anyfold'),
    Plugin('rhysd/accelerated-jk'),
    Plugin('rhysd/vim-clang-format'),
    Plugin('rhysd/vim-operator-surround'),
    Plugin('roxma/vim-hug-neovim-rpc'),
    Plugin('roxma/nvim-yarp'),
    Plugin('ryanoasis/vim-devicons'),
    Plugin('sbdchd/neoformat'),
    Plugin('SirVer/ultisnips'),
    Plugin('Shougo/context_filetype.vim'),
    Plugin('Shougo/dein.vim'),
    Plugin('Shougo/defx.nvim'),
    Plugin('Shougo/deoplete.nvim'),
    Plugin('Shougo/neco-vim'),
    Plugin('Shougo/neoyank.vim'),
    Plugin('Shougo/echodoc.vim'),
    Plugin('Shougo/denite.nvim'),
    Plugin('Shougo/neco-vim'),
    Plugin('Shougo/junkfile.vim'),
    Plugin('thinca/vim-fontzoom'),
    Plugin('thinca/vim-qfreplace'),
    Plugin('tyru/open-browser.vim'),
    Plugin('tyru/caw.vim'),
    Plugin('tell-k/vim-autopep8'),
    Plugin('terryma/vim-multiple-cursors'),
    Plugin('tpope/vim-fugitive'),
    Plugin('tpope/vim-surround'),
    Plugin('vim-jp/vital.vim'),
    Plugin('vim-airline/vim-airline-themes'),
    Plugin('vim-airline/vim-airline', patch=True),
    Plugin('voldikss/vim-translate-me'),
    Plugin('Yggdroot/indentLine'),
    Plugin('Yggdroot/LeaderF'),
    # Plugin('Valloric/YouCompleteMe'),
    # Plugin('python-mode/python-mode', rev=),
]
