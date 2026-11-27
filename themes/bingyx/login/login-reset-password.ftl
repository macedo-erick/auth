<#import "template.ftl" as layout>
<#assign usernameLabel = (!realm.loginWithEmailAllowed)?then(msg("username"),
    (!realm.registrationEmailAsUsername)?then(msg("usernameOrEmail"), msg("email")))>
<@layout.registrationLayout displayInfo=false displayMessage=!messagesPerField.existsError('username')
    subtitle=msg("bxResetSubtitle"); section>

    <#if section = "header">
        ${msg("bxResetTitle")}
    <#elseif section = "form">
      <form id="kc-reset-password-form" class="bx-form" action="${url.loginAction}" method="post" novalidate="novalidate">
        <@layout.textField id="username" name="username" label=usernameLabel
            value=(auth.attemptedUsername!'') autocomplete="username"
            error=messagesPerField.existsError('username') autofocus=true/>
        <@layout.fieldError name='username'/>

        <button type="submit" class="bx-btn">${msg("bxResetSubmit")}</button>

        <p class="bx-alt">
          <a class="bx-link" href="${url.loginUrl}">${msg("bxBackToLogin")}</a>
        </p>
      </form>
    </#if>
</@layout.registrationLayout>
