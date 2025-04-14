import { config } from '../../tokens/stitches.config'
import Image from 'next/image'
import Link from 'next/link'

export type RuminerFestiveLogoProps = {
  color?: string
  href?: string
}

export function RuminerFestiveLogo(
  props: RuminerFestiveLogoProps
): JSX.Element {
  const fillColor = props.color || config.theme.colors.graySolid
  const href = props.href || '/home'

  return (
    <Link
      passHref
      href={href}
      style={{
        textDecoration: 'none',
        display: 'flex',
        alignItems: 'center',
      }}
    >
      <Image
        src="/static/images/ruminer-logo-santa.png"
        width="27"
        height="27"
        alt=""
      />
    </Link>
  )
}
