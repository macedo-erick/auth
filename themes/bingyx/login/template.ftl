<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false subtitle="">
<!DOCTYPE html>
<html class="bx-html"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}" dir="${(locale.rtl)?then('rtl','ltr')}"</#if>>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, nofollow">
    <meta name="theme-color" content="#0b2318">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" type="image/svg+xml" href="${url.resourcesPath}/img/favicon.svg" />
    <link rel="icon" sizes="any" href="${url.resourcesPath}/img/favicon.ico" />
    <link rel="apple-touch-icon" href="${url.resourcesPath}/img/apple-touch-icon.png" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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

<body class="bx-body ${bodyClass}">
<div class="bx-snow" aria-hidden="true"></div>
<div class="bx-page">

  <header class="bx-top">
    <#assign homeUrl = (client?? && client.baseUrl?has_content)?then(client.baseUrl, '')>
    <${homeUrl?has_content?then('a','span')} class="bx-brand"<#if homeUrl?has_content> href="${homeUrl}"</#if>>
      <svg class="bx-star" viewBox="0 0 24 24" aria-hidden="true">
        <path d="M12 2l2.9 6.1 6.6.8-4.9 4.6 1.3 6.5L12 16.8 6.1 20l1.3-6.5L2.5 8.9l6.6-.8z"/>
      </svg>
      <span class="bx-brand-name">${realm.displayName!'Bingyx'}</span>
    </${homeUrl?has_content?then('a','span')}>
    <p class="bx-tagline">${msg("bxTagline")}</p>
  </header>

  <main class="bx-card">
    <div class="bx-card-copy">
      <h1 class="bx-title" id="kc-page-title"><#nested "header"></h1>
      <#if subtitle?has_content><p class="bx-subtitle">${subtitle}</p></#if>
      <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
        <div class="bx-identity">
          <span class="bx-identity-value">${auth.attemptedUsername}</span>
          <a class="bx-link" href="${url.loginRestartFlowUrl}">${msg("restartLoginTooltip")}</a>
        </div>
      </#if>
    </div>

    <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
      <div class="bx-alert bx-alert--${message.type}" role="alert">
        ${kcSanitize(message.summary)?no_esc}
      </div>
    </#if>

    <#nested "form">

    <#if auth?has_content && auth.showTryAnotherWayLink()>
      <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" novalidate="novalidate">
        <input type="hidden" name="tryAnotherWay" value="on"/>
        <button type="submit" class="bx-link-btn">${kcSanitize(msg("doTryAnotherWay"))?no_esc}</button>
      </form>
    </#if>

    <#nested "socialProviders">

    <#if displayInfo>
      <div class="bx-info"><#nested "info"></div>
    </#if>
  </main>

  <footer class="bx-foot">
    <#if realm.internationalizationEnabled && locale.supported?size gt 1>
      <label class="bx-locale">
        <span class="bx-sr">${msg("languages")}</span>
        <select onchange="if (this.value) window.location.href=this.value">
          <#list locale.supported?sort_by("label") as l>
            <option value="${l.url}" ${(l.languageTag == locale.currentLanguageTag)?then('selected','')}>${l.label}</option>
          </#list>
        </select>
      </label>
    </#if>
  </footer>

</div>

<script>
  // The eye button next to a password: one handler for every page that has one.
  document.addEventListener("click", function (event) {
    var button = event.target.closest("[data-reveal]");
    if (!button) return;
    var input = document.getElementById(button.getAttribute("data-reveal"));
    if (!input) return;
    var show = input.type === "password";
    input.type = show ? "text" : "password";
    button.setAttribute("aria-pressed", String(show));
  });
</script>
</body>
</html>
</#macro>

<#macro passwordField id name label autocomplete placeholder="" error=false autofocus=false>
  <div class="bx-field<#if error> bx-field--error</#if>">
    <label class="bx-label" for="${id}">${label}</label>
    <span class="bx-affix">
      <input class="bx-input" id="${id}" name="${name}" type="password" autocomplete="${autocomplete}"
             <#if placeholder?has_content>placeholder="${placeholder}"</#if>
             <#if autofocus>autofocus</#if> aria-invalid="${error?c}"/>
      <button type="button" class="bx-reveal" data-reveal="${id}" aria-pressed="false" aria-label="${msg('showPassword')}">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M2 12s3.6-6.5 10-6.5S22 12 22 12s-3.6 6.5-10 6.5S2 12 2 12Z"></path>
          <circle cx="12" cy="12" r="2.6"></circle>
        </svg>
      </button>
    </span>
  </div>
</#macro>

<#macro textField id name label value="" type="text" autocomplete="off" placeholder="" error=false autofocus=false>
  <div class="bx-field<#if error> bx-field--error</#if>">
    <label class="bx-label" for="${id}">${label}</label>
    <input class="bx-input" id="${id}" name="${name}" type="${type}" value="${value}" autocomplete="${autocomplete}"
           <#if placeholder?has_content>placeholder="${placeholder}"</#if>
           <#if autofocus>autofocus</#if> aria-invalid="${error?c}"/>
  </div>
</#macro>

<#macro fieldError name other="">
  <#if other?has_content>
    <#assign failed = messagesPerField.existsError(name, other)>
    <#assign first = failed?then(messagesPerField.getFirstError(name, other), '')>
  <#else>
    <#assign failed = messagesPerField.existsError(name)>
    <#assign first = failed?then(messagesPerField.getFirstError(name), '')>
  </#if>
  <#if failed>
    <p class="bx-error" aria-live="polite">${kcSanitize(first)?no_esc}</p>
  </#if>
</#macro>
