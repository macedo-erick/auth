<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false subtitle="">
<!DOCTYPE html>
<html class="stx-html"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}" dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, nofollow">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" type="image/svg+xml" href="${url.resourcesPath}/img/favicon.svg" />
    <link rel="icon" sizes="any" href="${url.resourcesPath}/img/favicon.ico" />
    <link rel="apple-touch-icon" href="${url.resourcesPath}/img/apple-touch-icon.png" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script>
        (function () {
            // Synchronous so no stylesheet paints before the theme class lands.
            var stored = localStorage.getItem("stampyx.theme");
            var dark = stored ? stored === "dark" : !window.matchMedia("(prefers-color-scheme: light)").matches;
            document.documentElement.classList.toggle("stx-dark", dark);
            document.documentElement.classList.toggle("pf-v5-theme-dark", dark);
        })();
    </script>
    <noscript><style>
      .stx-step[hidden] { display: block !important; }
      .stx-noscript-only { display: block !important; }
      .stx-suffix, .stx-steps, [data-address-echo], [data-goto-step] { display: none !important; }
    </style></noscript>
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="stx-body ${bodyClass}">
<div class="stx-page">

  <header class="stx-top">
    <#assign homeUrl = (client?? && client.baseUrl?has_content)?then(client.baseUrl, properties.stampyxSiteUrl!'')>
    <${homeUrl?has_content?then('a','span')} class="stx-brand"<#if homeUrl?has_content> href="${homeUrl}"</#if>>
      <span class="stx-brand-mark" aria-hidden="true">
        <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
          <rect x="2.5" y="5" width="19" height="14" rx="2.5" stroke="currentColor" stroke-width="1.8"/>
          <path d="M3.6 6.6 12 13l8.4-6.4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </span>
      <span class="stx-brand-name">${realm.displayName!'Stampyx'}</span>
    </${homeUrl?has_content?then('a','span')}>
    <button type="button" class="stx-icon-btn" onclick="stxToggleTheme()" aria-label="${msg('doToggleTheme')!'Toggle dark mode'}">
      <svg class="stx-icon stx-icon--sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <circle cx="12" cy="12" r="4"></circle>
        <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"></path>
      </svg>
      <svg class="stx-icon stx-icon--moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79Z"></path>
      </svg>
    </button>
  </header>

  <main class="stx-main">
    <div class="stx-card">
      <div class="stx-card-copy">
        <h1 class="stx-title" id="kc-page-title"><#nested "header"></h1>
        <#if subtitle?has_content><p class="stx-subtitle">${subtitle}</p></#if>
        <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
          <div class="stx-identity">
            <span class="stx-identity-value">${auth.attemptedUsername}</span>
            <a class="stx-identity-reset" href="${url.loginRestartFlowUrl}">${msg("restartLoginTooltip")}</a>
          </div>
        </#if>
      </div>

      <div class="stx-card-form">
        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
          <div class="stx-alert stx-alert--${message.type}" role="alert">
            <span>${kcSanitize(message.summary)?no_esc}</span>
          </div>
        </#if>

        <#nested "form">

        <#if auth?has_content && auth.showTryAnotherWayLink()>
          <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" novalidate="novalidate">
            <input type="hidden" name="tryAnotherWay" value="on"/>
            <button type="submit" class="stx-link-btn">${kcSanitize(msg("doTryAnotherWay"))?no_esc}</button>
          </form>
        </#if>

        <#nested "socialProviders">

        <#if displayInfo>
          <div class="stx-info"><#nested "info"></div>
        </#if>
      </div>
    </div>
  </main>

  <footer class="stx-foot">
    <#if realm.internationalizationEnabled && locale.supported?size gt 1>
      <label class="stx-locale">
        <span class="stx-sr">${msg("languages")}</span>
        <select onchange="if (this.value) window.location.href=this.value">
          <#list locale.supported?sort_by("label") as l>
            <option value="${l.url}" ${(l.languageTag == locale.currentLanguageTag)?then('selected','')}>${l.label}</option>
          </#list>
        </select>
      </label>
      <span class="stx-foot-dot" aria-hidden="true">&middot;</span>
    </#if>
    <a href="${properties.stampyxTermsUrl!'/terms'}">${msg("termsTitle")!'Terms of Use'}</a>
    <span class="stx-foot-dot" aria-hidden="true">&middot;</span>
    <a href="${properties.stampyxPrivacyUrl!'/privacy'}">Privacy Policy</a>
  </footer>

</div>

<script>
  function stxToggleTheme() {
    var dark = !document.documentElement.classList.contains("stx-dark");
    document.documentElement.classList.toggle("stx-dark", dark);
    document.documentElement.classList.toggle("pf-v5-theme-dark", dark);
    localStorage.setItem("stampyx.theme", dark ? "dark" : "light");
  }
</script>
</body>
</html>
</#macro>
