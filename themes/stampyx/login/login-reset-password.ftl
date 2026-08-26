<#import "template.ftl" as layout>
<#assign mailDomain = properties.stampyxMailDomain!'stampyx.com'>
<#assign attempted = (auth.attemptedUsername)!''>
<#assign localPart = attempted?contains('@')?then(attempted?keep_before('@'), attempted)>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username')
    subtitle="We will send reset instructions to your Stampyx mailbox. This is the panel password, not your mailbox password."; section>

    <#if section = "header">
        Reset your password
    <#elseif section = "form">
      <form id="kc-reset-password-form" class="stx-form" action="${url.loginAction}" method="post" novalidate="novalidate"
            data-mail-domain="${mailDomain}" data-initial-step="1">
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
          </label>
          <#if messagesPerField.existsError('username')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}</p>
          </#if>
          <p class="stx-hint stx-noscript-only">Type your full address, including @${mailDomain}.</p>

          <div class="stx-actions">
            <a class="stx-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            <button type="submit" class="stx-btn">${msg("doSubmit")}</button>
          </div>
        </section>
      </form>
      <script src="${url.resourcesPath}/js/stampyx-auth.js" defer></script>
    <#elseif section = "info">
      <#if realm.duplicateEmailsAllowed>${msg("emailInstructionUsername")}<#else>${msg("emailInstruction")}</#if>
    </#if>
</@layout.registrationLayout>
