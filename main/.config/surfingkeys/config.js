// TODO: WIP

// https://github.com/b0o/surfingkeys-conf

const {
    aceVimMap,
    mapkey,
    imap,
    imapkey,
    getClickableElements,
    vmapkey,
    map,
    unmap,
    vunmap,
    cmap,
    addSearchAlias,
    removeSearchAlias,
    tabOpenLink,
    readText,
    Clipboard,
    Front,
    Hints,
    Visual,
    RUNTIME
} = api;

map('J', 'u');
map('K', 'd');
map('<Alt-h>', '?');
map('<Ctrl-c>', '<Esc>');
cmap('<Ctrl-c>', '<Esc>');
vmapkey('<Ctrl-c>', '<Esc>');

map('gE', 'gg');
unmap('gg');
map('ge', 'G');
unmap('G');
vmapkey('gE', 'gg');
vunmap('gg');
vmapkey('ge', 'G');
vunmap('G');

vmapkey('_', 'j');
vmapkey('j', 'k');
vmapkey('k', '_');
vmapkey('_', 'h');
vmapkey(';', 'l');
vmapkey('l', '_');
vunmap('_');

cmap('<Ctrl-n>', '<Tab>');
cmap('<Ctrl-p>', '<Shift-Tab>');
cmap('<Tab>', '<Enter>');

settings.modeAfterYank = 'Normal';
Hints.characters = 'asdfghzxcvbnm,.qwertyuiop';
Hints.scrollKeys = '0kjl;G$';
settings.focusFirstCandidate = false;

mapkey('k', 'down', Normal.scroll.bind(Normal, 'down'));
mapkey('j', 'up', Normal.scroll.bind(Normal, 'up'));
mapkey('l', 'left', Normal.scroll.bind(Normal, 'left'));
mapkey(';', 'right', Normal.scroll.bind(Normal, 'right'));

addSearchAliasX('gr', 'https://www.goodreads.com/search?q=', '')
addSearchAliasX('gh', 'github', 'https://github.com/search?q=', 's');
addSearchAliasX('npm', 'npm', 'https://www.npmjs.com/search?q=', 's');
addSearchAliasX('lh', 'libhunt', 'https://www.libhunt.com/search?query=', 's');
addSearchAliasX(
  'mdn',
  'mdn',
  'https://developer.mozilla.org/en-US/search?q=',
  's',
);
addSearchAliasX(
  'arch',
  'archlinux wiki',
  'https://wiki.archlinux.org/index.php?search=',
  's',
);
addSearchAliasX(
  'pac',
  'arch packages',
  'https://archlinux.org/packages/?q=',
  's',
);
addSearchAliasX(
  'aur',
  'aur packages',
  'https://aur.archlinux.org/packages/?K=',
  's',
);

addSearchAliasX(
  'sea',
  'seriouseats',
  'https://www.seriouseats.com/search?q=',
  's',
);
addSearchAliasX(
  'nell',
  'nelligan',
  'https://nelligan.ville.montreal.qc.ca/search*frc/a?searchtype=Y&searcharg=',
  's',
);

addSearchAliasX(
  'p',
  'persée',
  'https://www.persee.fr/search?ta=article&q=',
  's',
);
addSearchAliasX(
  'sep',
  'sep',
  'https://plato.stanford.edu/search/searcher.py?query=',
  's',
);
addSearchAliasX(
  'c',
  'cairn',
  'https://www.cairn.info/resultats_recherche.php?searchTerm=',
  's',
);
addSearchAliasX(
  'fr',
  'francis',
  'https://pascal-francis.inist.fr/vibad/index.php?action=search&terms=',
  's',
);
addSearchAliasX(
  'eru',
  'erudit',
  'https://www.erudit.org/fr/recherche/?funds=%C3%89rudit&funds=UNB&basic_search_term=',
  's',
);
addSearchAliasX('c', 'cnrtl', 'https://www.cnrtl.fr/definition/', 's');
addSearchAliasX(
  'usi',
  'usito',
  'https://usito.usherbrooke.ca/d%C3%A9finitions/',
  's',
);
addSearchAliasX('we', 'wikipedia en', 'https://en.wikipedia.org/wiki/', 's');
addSearchAliasX('wf', 'wikipedia fr', 'https://fr.wikipedia.org/wiki/', 's');

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

const util = {};

util.getCurrentLocation = (prop = 'href') => {
  if (typeof window === 'undefined') {
    return '';
  }
  return window.location[prop];
};

const maxImg = (img) => {
  const srcs = img.srcset.split(',');
  let dim0 = 0;
  let url0;
  for (const src of srcs) {
    let [url, dim] = src.split(' ');
    dim = dim.trim().slice(0, dim.length - 1);
    if (dim > dim0) {
      dim0 = dim;
      url0 = url;
    }
  }
  return url0;
};

const openLink = (url, newTab = false, active = true) => {
  if (newTab) {
    RUNTIME('openLink', { tab: { tabbed: true, active }, url });
    return;
  }
  window.location.assign(url);
};

const actions = {};

const ajustedRe = /^([^&]*)/;
actions.copyAjustedUrl = () => {
  const href = util.getCurrentLocation('href');
  const m = href.match(ajustedRe);
  const id = m?.[1];
  if (id) {
    Clipboard.write(id);
  }
};

const githubIdReg = /:\/\/github\.com\/([\w-.]+\/[\w-.]+)/;
actions.copyGithubId = () => {
  const href = util.getCurrentLocation('href');
  const m = href.match(githubIdReg);
  const id = m?.[1];
  if (id) {
    Clipboard.write(id);
  }
};
actions.copyGithubSsh = () => {
  const href = util.getCurrentLocation('href');
  const m = href.match(githubIdReg);
  const id = m?.[1];
  if (id) {
    Clipboard.write('git@github.com:' + id);
  }
};

actions.copyMarkdownLink = () =>
  Clipboard.write(`[${document.title}](${util.getCurrentLocation('href')})`);

actions.openAnchor =
  ({ newTab = false, active = true, prop = 'href' } = {}) =>
  (a) =>
    actions.openLink(a[prop], { newTab, active })();

actions.openLink =
  (url, { newTab = false, active = true } = {}) =>
  () => {
    if (newTab) {
      RUNTIME('openLink', { tab: { tabbed: true, active }, url });
      return;
    }
    window.location.assign(url);
  };

// actions.openImgSet = ({ newTab = false, active = true } = {}) => (img) => actions.openLink(maxImg(img), { newTab, active })()

actions.openImgSet =
  ({ newTab = false, active = true } = {}) =>
  (img) =>
    actions.openLink('www.google.ca', { newTab, active })();

actions.showDns =
  ({ hostname = util.getCurrentLocation('hostname'), verbose = false } = {}) =>
  () => {
    let u = '';
    if (verbose) {
      u = `${ddossierUrl}?dom_whois=true&dom_dns=true&traceroute=true&net_whois=true&svc_scan=true&addr=${hostname}`;
    } else {
      u = `${ddossierUrl}?dom_dns=true&addr=${hostname}`;
    }
    actions.openLink(u, { newTab: true })();
  };

const googleCacheUrl = 'https://webcache.googleusercontent.com/search?q=cache:';

actions.showGoogleCache =
  ({ href = util.getCurrentLocation('href') } = {}) =>
  () =>
    actions.openLink(`${googleCacheUrl}${href}`, { newTab: true })();

const waybackUrl = 'https://web.archive.org/web/*/';

actions.showWayback =
  ({ href = util.getCurrentLocation('href') } = {}) =>
  () =>
    actions.openLink(`${waybackUrl}${href}`, { newTab: true })();

const outlineUrl = 'https://outline.com/';

actions.showOutline =
  ({ href = util.getCurrentLocation('href') } = {}) =>
  () =>
    actions.openLink(`${outlineUrl}${href}`, { newTab: true })();

actions.scrollToHash = (hash = null) => {
  const h = (hash || document.location.hash).replace('#', '');
  const e =
    document.getElementById(h) || document.querySelector(`[name="${h}"]`);
  if (!e) {
    return;
  }
  e.scrollIntoView({ behavior: 'smooth' });
};

actions.fakeSpot = (url = util.getCurrentLocation('href')) =>
  actions.openLink(`https://fakespot.com/analyze?ra=true&url=${url}`, {
    newTab: true,
    active: false,
  })();

createHints = (selector, action) => () => {
  if (typeof action === 'undefined') {
    // Use manual reassignment rather than a default arg so that we can lint/bundle without access
    // to the Hints object
    action = Hints.dispatchMouseClick; // eslint-disable-line no-param-reassign
  }
  Hints.create(selector, action);
};

actions.createHints = (selector, action) => () => {
  if (typeof action === 'undefined') {
    // Use manual reassignment rather than a default arg so that we can lint/bundle without access
    // to the Hints object
    action = Hints.dispatchMouseClick; // eslint-disable-line no-param-reassign
  }
  Hints.create(selector, action);
};

// Google
actions.go = {};
actions.go.parseLocation = () => {
  const u = new URL(util.getCurrentLocation());
  const q = u.searchParams.get('q');
  const p = u.pathname.split('/');

  const res = {
    type: 'unknown',
    url: u,
    query: q,
  };

  if (u.hostname === 'www.google.com') {
    // TODO: handle other ccTLDs
    if (p.length <= 1) {
      res.type = 'home';
    } else if (p[1] === 'search') {
      switch (u.searchParams.get('tbm')) {
        case 'vid':
          res.type = 'videos';
          break;
        case 'isch':
          res.type = 'images';
          break;
        case 'nws':
          res.type = 'news';
          break;
        default:
          res.type = 'web';
      }
    } else if (p[1] === 'maps') {
      res.type = 'maps';
      if (p[2] === 'search' && p[3] !== undefined) {
        res.query = p[3]; // eslint-disable-line prefer-destructuring
      } else if (p[2] !== undefined) {
        res.query = p[2]; // eslint-disable-line prefer-destructuring
      }
    }
  }

  return res;
};

actions.go.ddg = () => {
  const g = actions.go.parseLocation();

  const ddg = new URL('https://duckduckgo.com');
  if (g.query) {
    ddg.searchParams.set('q', g.query);
  }

  switch (g.type) {
    case 'videos':
      ddg.searchParams.set('ia', 'videos');
      ddg.searchParams.set('iax', 'videos');
      break;
    case 'images':
      ddg.searchParams.set('ia', 'images');
      ddg.searchParams.set('iax', 'images');
      break;
    case 'news':
      ddg.searchParams.set('ia', 'news');
      ddg.searchParams.set('iar', 'news');
      break;
    case 'maps':
      ddg.searchParams.set('iaxm', 'maps');
      break;
    case 'unknown':
    default:
      ddg.searchParams.set('ia', 'web');
      break;
  }

  actions.openLink(ddg.href)();
};

const domainOpts = (domain) => {
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#Escaping
  domain.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
  return {
    domain: new RegExp(`^http(s)?://(([a-zA-Z0-9-_]+\\.)*)(${domain})(/.*)?`),
  };
};
const leader = '<Space>';
unmap(leader);
const dmap0 = (domain, maps) =>
  maps.forEach(([keys, descr, cb]) =>
    mapkey(leader + keys, descr, cb, domainOpts(domain)),
  );
const dmap = (domains, maps) =>
  typeof domains == 'string'
    ? dmap0(domains, maps)
    : domains.forEach((domain) => dmap(domain, maps));

// generic
mapkey('ym', 'Copy page URL/Title as Markdown link', actions.copyMarkdownLink);
mapkey('yg', 'Copy github id', actions.copyGithubId);
mapkey('yG', 'Copy github ssh', actions.copyGithubSsh);
mapkey('yx', 'Copy ajusted url', actions.copyAjustedUrl);

// site specific

// - google

const googleSearchResultSelector = [
  'div.g>div>div>div>a', // "a h3",
  'h3 a',
  "a[href^='/search']:not(.fl):not(#pnnext,#pnprev):not([role]):not(.hide-focus-ring)",
  'g-scrolling-carousel a',
  '.rc > div:nth-child(2) a',
  '.kno-rdesc a',
  '.kno-fv a',
  '.isv-r > a:first-child',
  '.dbsr > a:first-child',
].join(',');
dmap('www.google.com', [
  ['a', 'Open search result', actions.createHints(googleSearchResultSelector)],
  [
    'A',
    'Open search result (new tab)',
    actions.createHints(
      googleSearchResultSelector,
      actions.openAnchor({ newTab: true, active: false }),
    ),
  ],
  ['d', 'Open search in DuckDuckGo', actions.go.ddg],
]);
dmap('www.instagram.com', [
  ['<Space>', 'Close', createHints('[aria-label="Close"]')],
  ['<Space>', 'Play', createHints('[aria-label="Contrôler"]')],
  ['n', 'Next image', createHints('div[class="    coreSpriteRightChevron  "]')],
  [
    'p',
    'Previous image',
    createHints('div[class="   coreSpriteLeftChevron   "]'),
  ],
  [
    'i',
    'Open image',
    createHints('img[srcset], style="padding-bottom: 66.4815%;" img', (img) =>
      openLink(maxImg(img), true),
    ),
  ],
]);
