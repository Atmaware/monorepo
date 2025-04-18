import { HStack, VStack } from '../../elements/LayoutPrimitives'
import { Button } from '../../elements/Button'
import { StyledText, StyledTextSpan } from '../../elements/StyledText'
import { useEffect, useRef, useState } from 'react'
import { BorderedFormInput, FormLabel } from '../../elements/FormElements'
import { fetchEndpoint } from '../../../lib/appConfig'
import { logoutMutation } from '../../../lib/networking/mutations/logoutMutation'
import { useRouter } from 'next/router'
import { parseErrorCodes } from '../../../lib/queryParamParser'
import { formatMessage } from '../../../locales/en/messages'
import Link from 'next/link'
import { Recaptcha } from '../../elements/Recaptcha'

const LoginForm = (): JSX.Element => {
  const [email, setEmail] = useState<string | undefined>()
  const [password, setPassword] = useState<string | undefined>()

  return (
    <VStack css={{ width: '100%', minWidth: '320px', gap: '16px', pb: '16px' }}>
      <VStack css={{ width: '100%', gap: '5px' }}>
        <FormLabel css={{ color: '#D9D9D9' }}>Email</FormLabel>
        <BorderedFormInput
          autoFocus={true}
          key="email"
          type="email"
          name="email"
          value={email}
          placeholder="Email"
          css={{ backgroundColor: '#2A2A2A', color: 'white', border: 'unset' }}
          onChange={(e) => {
            e.preventDefault()
            setEmail(e.target.value)
          }}
        />
      </VStack>

      <VStack css={{ width: '100%', gap: '5px' }}>
        <FormLabel css={{ color: '#D9D9D9' }}>Password</FormLabel>
        <BorderedFormInput
          key="password"
          type="password"
          name="password"
          value={password}
          placeholder="Password"
          css={{ bg: '#2A2A2A', color: 'white', border: 'unset' }}
          onChange={(e) => setPassword(e.target.value)}
        />
      </VStack>
    </VStack>
  )
}

export function EmailLogin(): JSX.Element {
  const router = useRouter()
  const [errorMessage, setErrorMessage] =
    useState<string | undefined>(undefined)
  const recaptchaTokenRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!router.isReady) return
    const errorCode = parseErrorCodes(router.query)
    const errorMsg = errorCode
      ? formatMessage({ id: `error.${errorCode}` })
      : undefined
    setErrorMessage(errorMsg)
  }, [router.isReady, router.query])

  return (
    <form action={`${fetchEndpoint}/auth/email-login`} method="POST">
      <VStack
        alignment="center"
        css={{
          padding: '20px',
          minWidth: '340px',
          width: '70vw',
          maxWidth: '576px',
          borderRadius: '8px',
          background: '#343434',
          border: '1px solid #6A6968',
          boxShadow: '0px 4px 4px 0px rgba(0, 0, 0, 0.15)',
        }}
      >
        <StyledText style="subHeadline" css={{ color: '#D9D9D9' }}>
          Login
        </StyledText>

        <LoginForm />

        {process.env.NEXT_PUBLIC_RECAPTCHA_CHALLENGE_SITE_KEY && (
          <>
            <Recaptcha
              setRecaptchaToken={(token) => {
                if (recaptchaTokenRef.current) {
                  recaptchaTokenRef.current.value = token
                } else {
                  console.log('error updating recaptcha token')
                }
              }}
            />
            <input
              ref={recaptchaTokenRef}
              type="hidden"
              name="recaptchaToken"
            />
          </>
        )}

        {errorMessage && <StyledText style="error">{errorMessage}</StyledText>}

        <HStack
          alignment="center"
          distribution="end"
          css={{
            gap: '10px',
            width: '100%',
            height: '80px',
          }}
        >
          <Button
            style={'cancelAuth'}
            type="button"
            onClick={async (event) => {
              window.localStorage.removeItem('authVerified')
              window.localStorage.removeItem('authToken')
              try {
                await logoutMutation()
              } catch (e) {
                console.log('error logging out', e)
              }
              window.location.href = '/'
            }}
          >
            Cancel
          </Button>
          <Button
            type="submit"
            style="ctaBlue"
            css={{
              padding: '10px 50px',
            }}
          >
            Login
          </Button>
        </HStack>
        <StyledText
          style="action"
          css={{
            m: '0px',
            pt: '16px',
            width: '100%',
            color: '$ruminerLightGray',
            textAlign: 'center',
            whiteSpace: 'normal',
          }}
        >
          Don&apos;t have an account?{' '}
          <Link href="/auth/email-signup" passHref legacyBehavior>
            <StyledTextSpan style="actionLink" css={{ color: '$ctaBlue' }}>
              Sign up
            </StyledTextSpan>
          </Link>
        </StyledText>
        <StyledText
          style="action"
          css={{
            mt: '0px',
            pt: '4px',
            width: '100%',
            color: '$ruminerLightGray',
            textAlign: 'center',
            whiteSpace: 'normal',
          }}
        >
          Forgot your password?{' '}
          <Link href="/auth/forgot-password" passHref legacyBehavior>
            <StyledTextSpan
              style="actionLink"
              css={{ color: '$ruminerLightGray' }}
            >
              Click here
            </StyledTextSpan>
          </Link>
        </StyledText>
      </VStack>
    </form>
  )
}
