map('<Alt-e>', 'E');
map('<Alt-r>', 'R');

addSearchAliasX('gh', 'github', 'https://github.com/search?q=', 's');
addSearchAliasX('npm', 'npm', 'https://www.npmjs.com/search?q=', 's');
addSearchAliasX('lh', 'libhunt', 'https://www.libhunt.com/search?query=', 's');
addSearchAliasX('mdn', 'mdn', 'https://developer.mozilla.org/en-US/search?q=', 's');
addSearchAliasX('arch', 'archlinux wiki', 'https://wiki.archlinux.org/index.php?search=', 's');
addSearchAliasX('pac', 'arch packages', 'https://archlinux.org/packages/?q=', 's');
addSearchAliasX('aur', 'aur packages', 'https://aur.archlinux.org/packages/?K=', 's');

addSearchAliasX('sea', 'seriouseats', 'https://www.seriouseats.com/search?q=', 's');
addSearchAliasX('nell', 'nelligan', 'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=', 's');

addSearchAliasX('p', 'persée', 'https://www.persee.fr/search?ta=article&q=', 's');
addSearchAliasX('sep', 'sep', 'https://plato.stanford.edu/search/searcher.py?query=', 's');
addSearchAliasX('c', 'cairn', 'https://www.cairn.info/resultats_recherche.php?searchTerm=', 's');
addSearchAliasX('fr', 'francis', 'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=', 's');
addSearchAliasX('eru', 'erudit', 'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=', 's');

addSearchAliasX('c', 'cnrtl', 'https://www.cnrtl.fr/definition/', 's');
addSearchAliasX('usi', 'usito', 'https://usito.usherbrooke.ca/d%C3%A9finitions/', 's');

// an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
// map('gt', 't');

// an example to remove mapkey `Ctrl-i`
// unmap('<ctrl-i>');

// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
// click `Save` button to make above settings to take effect
