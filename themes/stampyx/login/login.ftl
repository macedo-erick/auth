<#import "template.ftl" as layout>
<#assign mailDomain = properties.stampyxMailDomain!'stampyx.com'>
<#assign attempted = (login.username)!''>
<#assign localPart = attempted?contains('@')?then(attempted?keep_before('@'), attempted)>
<#assign skipAddress = usernameHidden?? || (auth?has_content && auth.showUsername())>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password')
    subtitle="Enter your email address"; section>

    <#if section = "header">
        Welcome back to Stampyx
    <#elseif section = "form">
      <form id="kc-form-login" class="stx-form" action="${url.loginAction}" method="post" novalidate="novalidate"
            data-mail-domain="${mailDomain}" data-initial-step="${(skipAddress || localPart?has_content)?then('2','1')}">

        <#if !skipAddress>
        <section class="stx-step" data-step="1">
          <label class="stx-field <#if messagesPerField.existsError('username')>stx-field--error</#if>">
            <span class="stx-label">${msg("email")}</span>
            <span class="stx-affix">
              <input class="stx-input" id="username" name="username" type="text" autofocus data-address
                     value="${localPart}" autocomplete="username" spellcheck="false"
                     inputmode="email" placeholder="e.g. alfie.hitchcock"
                     aria-invalid="${messagesPerField.existsError('username')?c}"/>
              <span class="stx-suffix" aria-hidden="true">@${mailDomain}</span>
            </span>
            <span class="stx-sr">All Stampyx addresses end in @${mailDomain}.</span>
          </label>
          <#if messagesPerField.existsError('username')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}</p>
          </#if>
          <p class="stx-hint stx-noscript-only">Type your full address, including @${mailDomain}.</p>

          <div class="stx-actions">
            <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
              <a class="stx-link" href="${url.registrationUrl}">${msg("doRegister")}</a>
            </#if>
            <button type="button" class="stx-btn" data-goto-step="2">${msg("doContinue")}</button>
          </div>
        </section>
        </#if>

        <section class="stx-step" data-step="2" hidden>
          <#if !skipAddress>
          <div class="stx-identity">
            <span class="stx-identity-value" data-address-echo>&nbsp;</span>
            <button type="button" class="stx-link-btn" data-goto-step="1">Change</button>
          </div>
          </#if>

          <label class="stx-field <#if messagesPerField.existsError('username','password')>stx-field--error</#if>">
            <span class="stx-label">${msg("password")}</span>
            <span class="stx-affix">
              <input class="stx-input" id="password" name="password" type="password"
                     autocomplete="current-password" placeholder="Your password"
                     aria-invalid="${messagesPerField.existsError('username','password')?c}"/>
              <button type="button" class="stx-reveal" data-reveal="password" aria-label="${msg('showPassword')}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <path d="M2 12s3.6-6.5 10-6.5S22 12 22 12s-3.6 6.5-10 6.5S2 12 2 12Z"></path>
                  <circle cx="12" cy="12" r="2.6"></circle>
                </svg>
              </button>
            </span>
          </label>
          <#if messagesPerField.existsError('username','password')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</p>
          </#if>

          <div class="stx-row">
            <#if realm.rememberMe && !usernameHidden??>
              <label class="stx-check">
                <input type="checkbox" name="rememberMe" <#if login.rememberMe??>checked</#if>/>
                <span>${msg("rememberMe")}</span>
              </label>
            </#if>
            <#if realm.resetPasswordAllowed>
              <a class="stx-link stx-link--quiet" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
            </#if>
          </div>

          <div class="stx-actions">
            <#if !skipAddress>
              <button type="button" class="stx-link-btn" data-goto-step="1">Back</button>
            </#if>
            <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
            <button type="submit" class="stx-btn" name="login">${msg("doLogIn")}</button>
          </div>
        </section>
      </form>

      <script src="${url.resourcesPath}/js/stampyx-auth.js" defer></script>

    <#elseif section = "socialProviders">
      <#if realm.password && social?? && social.providers?has_content>
        <div class="stx-social">
          <#list social.providers as p>
            <a class="stx-social-btn" href="${p.loginUrl}" id="social-${p.alias}">${p.displayName!}</a>
          </#list>
        </div>
      </#if>
    </#if>
</@layout.registrationLayout>
