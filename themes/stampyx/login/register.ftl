<#import "template.ftl" as layout>
<#assign mailDomain = properties.stampyxMailDomain!'stampyx.com'>

<#-- Steps are derived from the user profile so adding an attribute does not strand it
     off-form: the address is always step 1, everything else profile-declared is step 2,
     and credentials are step 3. -->
<#assign profileAttrs = []>
<#assign values = {}>
<#if profile?? && profile.attributes??>
  <#list profile.attributes as attr>
    <#assign values = values + { attr.name : (attr.value!'') }>
    <#if attr.name != 'email' && attr.name != 'username' && !(attr.readOnly!false)>
      <#assign profileAttrs = profileAttrs + [attr]>
    </#if>
  </#list>
</#if>
<#assign emailValue = values['email']!''>
<#assign emailLocal = emailValue?contains('@')?then(emailValue?keep_before('@'), emailValue)>

<#assign detailsHaveError = false>
<#list profileAttrs as attr>
  <#if messagesPerField.existsError(attr.name)><#assign detailsHaveError = true></#if>
</#list>
<#assign initialStep = 1>
<#if !messagesPerField.existsError('email','username')>
  <#if detailsHaveError>
    <#assign initialStep = 2>
  <#elseif messagesPerField.existsError('password','password-confirm','termsAccepted')>
    <#assign initialStep = 3>
  </#if>
</#if>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global')
    subtitle="Pick your address, then set a password. Three steps, about a minute."; section>

    <#if section = "header">
        Create your Stampyx address
    <#elseif section = "form">
      <form id="kc-register-form" class="stx-form" action="${url.registrationAction}" method="post" novalidate="novalidate"
            data-mail-domain="${mailDomain}" data-initial-step="${initialStep}">

        <ol class="stx-steps" aria-hidden="true">
          <li data-step-dot="1">Address</li>
          <#if profileAttrs?has_content><li data-step-dot="2">Details</li></#if>
          <li data-step-dot="3">Password</li>
        </ol>

        <section class="stx-step" data-step="1" hidden>
          <label class="stx-field <#if messagesPerField.existsError('email','username')>stx-field--error</#if>">
            <span class="stx-label">${msg("email")}</span>
            <span class="stx-affix">
              <input class="stx-input" id="email" name="email" type="text" autofocus data-address
                     value="${emailLocal}" autocomplete="username" spellcheck="false"
                     inputmode="email" placeholder="e.g. alfie.hitchcock"
                     aria-describedby="stx-email-help"
                     aria-invalid="${messagesPerField.existsError('email','username')?c}"/>
              <span class="stx-suffix" aria-hidden="true">@${mailDomain}</span>
            </span>
            <span class="stx-help" id="stx-email-help">Letters, numbers, dots, hyphens. This is the mailbox you will sign in with.</span>
          </label>
          <#if values['username']??>
            <input type="hidden" id="username" name="username" data-address-mirror value="${values['username']!''}"/>
          </#if>
          <#if messagesPerField.existsError('email','username')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('email','username'))?no_esc}</p>
          </#if>
          <p class="stx-hint stx-noscript-only">Type your full address, including @${mailDomain}.</p>

          <div class="stx-actions">
            <a class="stx-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            <button type="button" class="stx-btn" data-goto-step="<#if profileAttrs?has_content>2<#else>3</#if>">${msg("doContinue")}</button>
          </div>
        </section>

        <#if profileAttrs?has_content>
        <section class="stx-step" data-step="2" hidden>
          <div class="stx-identity">
            <span class="stx-identity-value" data-address-echo>&nbsp;</span>
            <button type="button" class="stx-link-btn" data-goto-step="1">Change</button>
          </div>

          <#list profileAttrs as attr>
            <label class="stx-field <#if messagesPerField.existsError(attr.name)>stx-field--error</#if>">
              <span class="stx-label">${advancedMsg(attr.displayName!'')}<#if attr.required!false> <span class="stx-req" aria-hidden="true">*</span></#if></span>
              <span class="stx-affix">
                <input class="stx-input" id="${attr.name}" name="${attr.name}"
                       type="${(attr.annotations.inputType)!'text'}"
                       value="${values[attr.name]!''}"
                       <#if attr.required!false>data-required="true"</#if>
                       autocomplete="${(attr.autocomplete)!'on'}"
                       aria-invalid="${messagesPerField.existsError(attr.name)?c}"/>
              </span>
              <#if messagesPerField.existsError(attr.name)>
                <span class="stx-error">${kcSanitize(messagesPerField.getFirstError(attr.name))?no_esc}</span>
              </#if>
            </label>
          </#list>

          <div class="stx-actions">
            <button type="button" class="stx-link-btn" data-goto-step="1">Back</button>
            <button type="button" class="stx-btn" data-goto-step="3">${msg("doContinue")}</button>
          </div>
        </section>
        </#if>

        <section class="stx-step" data-step="3" hidden>
          <div class="stx-identity">
            <span class="stx-identity-value" data-address-echo>&nbsp;</span>
            <button type="button" class="stx-link-btn" data-goto-step="1">Change</button>
          </div>

          <#if passwordRequired??>
          <label class="stx-field <#if messagesPerField.existsError('password')>stx-field--error</#if>">
            <span class="stx-label">${msg("password")}</span>
            <span class="stx-affix">
              <input class="stx-input" id="password" name="password" type="password"
                     autocomplete="new-password" data-required="true"
                     aria-describedby="stx-password-help"
                     aria-invalid="${messagesPerField.existsError('password')?c}"/>
              <button type="button" class="stx-reveal" data-reveal="password" aria-label="${msg('showPassword')}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <path d="M2 12s3.6-6.5 10-6.5S22 12 22 12s-3.6 6.5-10 6.5S2 12 2 12Z"></path>
                  <circle cx="12" cy="12" r="2.6"></circle>
                </svg>
              </button>
            </span>
            <span class="stx-help" id="stx-password-help"></span>
          </label>
          <#if messagesPerField.existsError('password')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('password'))?no_esc}</p>
          </#if>

          <label class="stx-field <#if messagesPerField.existsError('password-confirm')>stx-field--error</#if>">
            <span class="stx-label">${msg("passwordConfirm")}</span>
            <span class="stx-affix">
              <input class="stx-input" id="password-confirm" name="password-confirm" type="password"
                     autocomplete="new-password" data-required="true"
                     aria-invalid="${messagesPerField.existsError('password-confirm')?c}"/>
            </span>
            <#if messagesPerField.existsError('password-confirm')>
              <span class="stx-error">${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}</span>
            </#if>
          </label>
          </#if>

          <#if termsAcceptanceRequired??>
          <label class="stx-check stx-check--block <#if messagesPerField.existsError('termsAccepted')>stx-field--error</#if>">
            <input type="checkbox" id="termsAccepted" name="termsAccepted" value="on" data-required="true"
                   <#if (register.formData.termsAccepted)?? >checked</#if>/>
            <span>${kcSanitize(msg("termsText"))?no_esc}</span>
          </label>
          <#if messagesPerField.existsError('termsAccepted')>
            <p class="stx-error" aria-live="polite">${kcSanitize(messagesPerField.getFirstError('termsAccepted'))?no_esc}</p>
          </#if>
          </#if>

          <#if recaptchaRequired?? && (recaptchaVisible!false)>
            <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
          </#if>

          <div class="stx-actions">
            <button type="button" class="stx-link-btn" data-goto-step="<#if profileAttrs?has_content>2<#else>1</#if>">Back</button>
            <button type="submit" class="stx-btn">${msg("doRegister")}</button>
          </div>
        </section>
      </form>

      <script>
        window.stxPasswordPolicies = [
          { name: "length", value: ${passwordPolicies.length!-1}, error: "${msg('invalidPasswordMinLengthMessage', '{0}')?js_string}" },
          { name: "maxLength", value: ${passwordPolicies.maxLength!-1}, error: "${msg('invalidPasswordMaxLengthMessage', '{0}')?js_string}" },
          { name: "lowerCase", value: ${passwordPolicies.lowerCase!-1}, error: "${msg('invalidPasswordMinLowerCaseCharsMessage', '{0}')?js_string}" },
          { name: "upperCase", value: ${passwordPolicies.upperCase!-1}, error: "${msg('invalidPasswordMinUpperCaseCharsMessage', '{0}')?js_string}" },
          { name: "digits", value: ${passwordPolicies.digits!-1}, error: "${msg('invalidPasswordMinDigitsMessage', '{0}')?js_string}" },
          { name: "specialChars", value: ${passwordPolicies.specialChars!-1}, error: "${msg('invalidPasswordMinSpecialCharsMessage', '{0}')?js_string}" }
        ].filter(function (p) { return p.value !== -1; });
      </script>
      <script src="${url.resourcesPath}/js/stampyx-auth.js" defer></script>
    </#if>
</@layout.registrationLayout>
