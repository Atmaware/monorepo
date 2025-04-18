import Link from 'next/link'
import { useRouter } from 'next/router'
import { DEFAULT_HOME_PATH } from '../../../lib/navigations'
import { Box } from '../LayoutPrimitives'
export type RuminerLogoBaseProps = {
  color?: string
  href?: string
  showTitle?: boolean
  children: React.ReactNode
}

export function RuminerLogoBase(props: RuminerLogoBaseProps): JSX.Element {
  const router = useRouter()

  return (
    <Box
      style={{
        textDecoration: 'none',
        display: 'flex',
        alignItems: 'center',
        cursor: 'pointer',
      }}
      onClick={(event) => {
        if (props.href) {
          router.push(props.href)
          return
        }
        const navReturn = window.localStorage.getItem('nav-return')
        if (navReturn) {
          router.push(navReturn)
          return
        }
        const query = window.sessionStorage.getItem('q')
        if (query) {
          router.push(`${DEFAULT_HOME_PATH}?${query}`)
        } else {
          router.push(DEFAULT_HOME_PATH)
        }
      }}
      tabIndex={-1}
      aria-label="Ruminer logo"
    >
      {props.children}
    </Box>
  )
}
