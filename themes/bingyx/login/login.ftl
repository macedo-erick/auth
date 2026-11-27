<#import "template.ftl" as layout>
<#assign usernameLabel = (!realm.loginWithEmailAllowed)?then(msg("username"),
    (!realm.registrationEmailAsUsername)?then(msg("usernameOrEmail"), msg("email")))>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password')
    subtitle=msg("bxLoginSubtitle"); section>

    <#if section = "header">
        ${msg("bxLoginTitle")}
    <#elseif section = "form">
      <form id="kc-form-login" class="bx-form" action="${url.loginAction}" method="post" novalidate="novalidate">
        <#assign credentialError = messagesPerField.existsError('username','password')>

        <#if !usernameHidden??>
          <@layout.textField id="username" name="username" label=usernameLabel value=(login.username!'')
              autocomplete="username" error=credentialError autofocus=true/>
        </#if>

        <@layout.passwordField id="password" name="password" label=msg("password")
            autocomplete="current-password" error=credentialError autofocus=usernameHidden??/>
        <@layout.fieldError name='username' other='password'/>

        <div class="bx-row">
          <#if realm.rememberMe && !usernameHidden??>
            <label class="bx-check">
              <input type="checkbox" name="rememberMe" <#if login.rememberMe??>checked</#if>/>
              <span>${msg("rememberMe")}</span>
            </label>
          <#else>
            <span></span>
          </#if>
          <#if realm.resetPasswordAllowed>
            <a class="bx-link" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
          </#if>
        </div>

        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
        <button type="submit" class="bx-btn" name="login" id="kc-login">${msg("doLogIn")}</button>

        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
          <p class="bx-alt">
            ${msg("bxNoAccount")} <a class="bx-link" href="${url.registrationUrl}">${msg("bxCreateAccount")}</a>
          </p>
        </#if>
      </form>

    <#elseif section = "socialProviders">
      <#if realm.password && social?? && social.providers?has_content>
        <div class="bx-social">
          <#list social.providers as p>
            <a class="bx-btn bx-btn--ghost" href="${p.loginUrl}" id="social-${p.alias}">${p.displayName!}</a>
          </#list>
        </div>
      </#if>
    </#if>
</@layout.registrationLayout>
