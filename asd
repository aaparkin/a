import React, {memo, FunctionComponent} from 'react'
import {MappedError} from 'bbb-gp-common/blocks/mapped-errors'
import {toI18n} from 'src/tools/i18n'
import {ParsedError} from 'src/tools/parse-error'
import {UserSlicedGeneralSettings} from 'src/api/configuration-types'
import {UserGlobalSettings} from 'src/api/user-settings-types'
import {AuiSpinner} from 'src/blocks/aui/AuiSpinner'
import {AuiToggle} from 'src/blocks/aui/AuiToggle'
import {AuiLabel} from 'src/blocks/aui/AuiLabel'
import {isDeepLinkingUserEnabled} from 'src/deeplinking/tools/settings-helpers'
import {WHAT_IS_KRAKEN_URL} from 'src/deeplinking/tools/kraken-urls'
import type {UserGlobalSettingsSaveStatus} from 'src/actions/user-settings-page-actions'
import { KrakenMiniLogo, LensMiniLogo } from 'src/deeplinking/blocks/kraken-popup/kraken-popup'
import { useSelector } from 'react-redux'


import { getRouting } from 'src/actions/jira-routing'

interface UserGlobalSettingsSectionVals {
  installSettings: UserSlicedGeneralSettings | null
  userGlobalSettings: UserGlobalSettings | null
  globalSettingsError: null | ParsedError
  userGlobalSettingsSaveStatus: UserGlobalSettingsSaveStatus
}

interface UserGlobalSettingsSectionFuns {
  changeIsGkDeepLinkingEnabled(checked:boolean):void
  changeIsGlDeepLinkingEnabled(checked:boolean):void
}

type UserGlobalSettingsSectionProps = UserGlobalSettingsSectionVals & UserGlobalSettingsSectionFuns

const UserGlobalSettingsSection:FunctionComponent<UserGlobalSettingsSectionProps> = memo(
  function UserGlobalsettingsSection(props) {
    const {installSettings, userGlobalSettings, globalSettingsError} = props
    return (
      <>
        <h2>{toI18n('Connected apps')}</h2>
        <br/>
        {globalSettingsError && <MappedError {...globalSettingsError}/>}
        {!installSettings && !userGlobalSettings && !globalSettingsError
          ? <AuiSpinner/>
          : <UserGlobalSettingsSectionContent {...props}/>
        }
      </>
    )
  }
)

const UserGlobalSettingsSectionContent:FunctionComponent<UserGlobalSettingsSectionProps> = memo(
  function UserGlobalSettingsSectionContent(props) {
    const {installSettings, userGlobalSettings, userGlobalSettingsSaveStatus, changeIsGkDeepLinkingEnabled,
      changeIsGlDeepLinkingEnabled} = props
    const {
      isSavingGkDeepLinkingEnabledForUser,
      isSavingGlDeepLinkingEnabledForUser
    } = userGlobalSettingsSaveStatus
    const {idfy} = props as any
    const {gkDeepLinkingEnabled, glDeepLinkingEnabled} = installSettings || {}
    const {gkDeepLinkingEnabledForUser, glDeepLinkingEnabledForUser} = userGlobalSettings || {}
    const krakenDeepLinkingChecked = isDeepLinkingUserEnabled(gkDeepLinkingEnabledForUser, gkDeepLinkingEnabled)
    const lensDeepLinkingChecked = isDeepLinkingUserEnabled(glDeepLinkingEnabledForUser, glDeepLinkingEnabled)
    const krakenToggleId = idfy('toggle-gk-deeplinking-enabled')
    const lensToggleId = idfy('toggle-gl-deeplinking-enabled')

    // TODO: remove it in GITCL-2878
    const {gitLens} = useSelector(getRouting).showHiddenFeatures

    return (
      <div>
        <div className='bbb-gp-configuration-user-settings__form-field'>
          <AuiLabel htmlFor={krakenToggleId}>
            <div className='bbb-gp-configuration-user-settings__form-field-toggle-part'>
              <AuiToggle
                label={toI18n('Toggle GitKraken integration. Now is {0}', krakenDeepLinkingChecked ? toI18n('enabled') : toI18n('disabled') )}
                id={krakenToggleId}
                checked={krakenDeepLinkingChecked}
                busy={isSavingGkDeepLinkingEnabledForUser}
                onClick={changeIsGkDeepLinkingEnabled}
              />
            </div>
          </AuiLabel>
          <div className='bbb-gp-configuration-user-settings__form-field-description-part'>
            <div><KrakenMiniLogo/> <h4>GitKraken</h4></div>
            <p className='bbb-gp-configuration-user-settings__form-field-paragraph'>
              {toI18n('You can open commits, branches, tags and repositories in GitKraken right from Jira ')}
              {toI18n('(click the ')}
              <u>{toI18n('GitKraken')}</u>
              {toI18n(' buttons) to use this feature. ')}
              <a href={WHAT_IS_KRAKEN_URL} target='_blank'>
                {toI18n('Learn more')}
              </a>
            </p>
          </div>
        </div>
        {gitLens ?
          <div className='bbb-gp-configuration-user-settings__form-field'>
            <AuiLabel htmlFor={lensToggleId}>
              <div className='bbb-gp-configuration-user-settings__form-field-toggle-part'>
                <AuiToggle
                  label={toI18n('Toggle GitKraken integration. Now is {0}', krakenDeepLinkingChecked ? toI18n('enabled') : toI18n('disabled') )}
                  id={lensToggleId}
                  checked={lensDeepLinkingChecked}
                  busy={isSavingGlDeepLinkingEnabledForUser}
                  onClick={changeIsGlDeepLinkingEnabled}
                />
              </div>
            </AuiLabel>
            <div className='bbb-gp-configuration-user-settings__form-field-description-part'>
              <div><LensMiniLogo/> <h4>GitLens</h4></div>
              <p className='bbb-gp-configuration-user-settings__form-field-paragraph'>
                {toI18n('You can open commits, branches, tags and repositories in VS Code right from Jira ')}
                {toI18n('(click the ')}
                <u>{toI18n('GitLens')}</u>
                {toI18n(' buttons) to use this feature. ')}
                <a href={WHAT_IS_KRAKEN_URL} target='_blank'>
                  {toI18n('Learn more')}
                </a>
              </p>
            </div>
          </div>
          : null}
        {/* future form fields go here */}
      </div>
    )
  }
)

export type {
  UserGlobalSettingsSectionVals,
  UserGlobalSettingsSectionFuns,
}

export {
  UserGlobalSettingsSection,
}
export default UserGlobalSettingsSection
