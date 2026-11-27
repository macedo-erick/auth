<#import "template.ftl" as layout>
<#-- The organiser's name is what the app greets them with and what their own card carries
     when they play, so first and last name are asked for here rather than later. -->
<#assign values = {}>
<#if profile?? && profile.attributes??>
  <#list profile.attributes as attr>
    <#assign values = values + { attr.name : (attr.value!'') }>
  </#list>
</#if>
<@layout.registrationLayout displayMessage=messagesPerField.exists('global')
    subtitle=msg("bxRegisterSubtitle"); section>

    <#if section = "header">
        ${msg("bxRegisterTitle")}
    <#elseif section = "form">
      <form id="kc-register-form" class="bx-form" action="${url.registrationAction}" method="post" novalidate="novalidate">

        <div class="bx-pair">
          <div>
            <@layout.textField id="firstName" name="firstName" label=msg("firstName") value=(values['firstName']!'')
                autocomplete="given-name" error=messagesPerField.existsError('firstName') autofocus=true/>
            <@layout.fieldError name='firstName'/>
          </div>
          <div>
            <@layout.textField id="lastName" name="lastName" label=msg("lastName") value=(values['lastName']!'')
                autocomplete="family-name" error=messagesPerField.existsError('lastName')/>
            <@layout.fieldError name='lastName'/>
          </div>
        </div>

        <@layout.textField id="email" name="email" type="email" label=msg("email") value=(values['email']!'')
            autocomplete="email" error=messagesPerField.existsError('email')/>
        <@layout.fieldError name='email'/>

        <#if !realm.registrationEmailAsUsername>
          <@layout.textField id="username" name="username" label=msg("username") value=(values['username']!'')
              autocomplete="username" error=messagesPerField.existsError('username')/>
          <@layout.fieldError name='username'/>
        </#if>

        <#if passwordRequired??>
          <@layout.passwordField id="password" name="password" label=msg("password")
              autocomplete="new-password" error=messagesPerField.existsError('password','password-confirm')/>
          <@layout.fieldError name='password'/>
          <p class="bx-help">${msg("bxPasswordPolicy")}</p>

          <@layout.passwordField id="password-confirm" name="password-confirm" label=msg("passwordConfirm")
              autocomplete="new-password" error=messagesPerField.existsError('password-confirm')/>
          <@layout.fieldError name='password-confirm'/>
        </#if>

        <#if recaptchaRequired?? && (recaptchaVisible!false)>
          <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
        </#if>

        <button type="submit" class="bx-btn">${msg("bxCreateAccountSubmit")}</button>

        <p class="bx-alt">
          ${msg("bxHaveAccount")} <a class="bx-link" href="${url.loginUrl}">${msg("doLogIn")}</a>
        </p>
      </form>
    </#if>
</@layout.registrationLayout>
