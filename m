Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23FE11197
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Feb 2024 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707907492; cv=none; b=OUulN3nJH9RoiH2Q8XKzukmFHzTI50K1SScPNDndXsSgAQt8CmcfQ6H7AsFo9JinvW1wZ9nM3St1qztlvTizvMAMyn0Pmd/rrenW5QClQY5ZMl/Gh/yNKACLu1ZfyU1EVblmqjoujHWdVa2yN1eHePkYODUrSFADViN2CjgcuKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707907492; c=relaxed/simple;
	bh=vdUVMSN/DBEbi9xLtereQlPEved8sJ0OAE7THRyHVaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=ISVDO3fgyctl4WWgYYrXbxRuIfsWzHQO/uDU26P6z0Kurp6GAh6D4mGZoAL2yE3W4WB3m/xr9vE+5HmhMpZLXaBuAPfHVwdotnYY9DlnX38vSicnLMbQ/m9wGywKvcdoCSnY3r15J091T0WO1broWr8kgNisvef1k8HrN9ltp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-56-wLKyE-NdNOaDYt-85i9Meg-1; Wed, 14 Feb 2024 10:42:20 +0000
X-MC-Unique: wLKyE-NdNOaDYt-85i9Meg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 14 Feb
 2024 10:41:59 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 14 Feb 2024 10:41:59 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kent Overstreet' <kent.overstreet@linux.dev>, Nathan Chancellor
	<nathan@kernel.org>
CC: "llvm@lists.linux.dev" <llvm@lists.linux.dev>, Will Deacon
	<will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: RE: static assertion failed in fs/bcachefs/journal_io.c
Thread-Topic: static assertion failed in fs/bcachefs/journal_io.c
Thread-Index: AQHaXuOGUA5YsYgoKEe2qel95jLubrEJmFgw
Date: Wed, 14 Feb 2024 10:41:59 +0000
Message-ID: <b91d20f513e642669f716a217f15f9de@AcuMS.aculab.com>
References: <20240213215640.GA80329@dev-arch.thelio-3990X>
 <wl7u2f7gvrw5yeyoa4rit4fy5kepn5tmqgzelrduhpajqvcuxy@4imci5mhzecr>
In-Reply-To: <wl7u2f7gvrw5yeyoa4rit4fy5kepn5tmqgzelrduhpajqvcuxy@4imci5mhzecr>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Kent Overstreet
> Sent: 14 February 2024 01:17
>=20
> bcachefs bugs should go to the bcachefs mailing list; I assume this is
> just a case where we need min_t instead of min, if so I'll fix it
> shortly

You should pretty much never use min_t() - it contains casts that are just
waiting to cause grief.

I'm sure a bug got raised on clang so it outputting the source of the
_Static_assert() when there is a message.
That just makes the error message worse.

Hacking at the error message, it comes from (expanded by min()):

min(replicas_want, ({
    do {
        __attribute__((__noreturn__))
            extern void __compiletime_assert_578(void)
            __attribute__((__error__("Unsupported access size for {READ,WRI=
TE}_ONCE().")));
        if (...)
            __compiletime_assert_578();
    } while (0);
    ({
        typeof(&(c->opts.metadata_replicas_required)) __x =3D &(c->opts.met=
adata_replicas_required);
        int atomic =3D 1;
        union {
            typeof( _Generic((*__x),
                char: (char)0,
                unsigned char: (unsigned char)0,
                signed char: (signed char)0,
                unsigned short: (unsigned short)0,
                signed short: (signed short)0,
                unsigned int: (unsigned int)0,
                signed int: (signed int)0,
                unsigned long: (unsigned long)0,
                signed long: (signed long)0,
                unsigned long long: (unsigned long long)0,
                signed long long: (signed long long)0,
                default: (*__x))) __val;
            char __c[1];
        } __u;
        switch (sizeof(c->opts.metadata_replicas_required)) {
        case 1: asm volatile("..." : "=3Dr" (*(__u8 *)__u.__c) : "Q" (*__x)=
 : "memory");
            break;
        case 2: asm volatile("..." : "=3Dr" (*(__u16 *)__u.__c) : "Q" (*__x=
) : "memory");
            break;
        case 4: asm volatile("..." : "=3Dr" (*(__u32 *)__u.__c) : "Q" (*__x=
) : "memory");
            break;
        case 8: asm volatile("..." : "=3Dr" (*(__u64 *)__u.__c) : "Q" (*__x=
) : "memory");
            break;
        default:
            atomic =3D 0;
        }
        atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(__x))__x);
    });
}))

So I suspect it is min(replicas_want, READ_ONCE(replices_required)).
I think replicas_want is unsigned (int) and replicas_required u8.

>=20
> On Tue, Feb 13, 2024 at 02:56:40PM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > I am not really sure where to go with this, so I figured I would loop
> > some people in and see if we can figure out what is going on here.
> >
> > After commit 67a8e7de7ef0 ("bcachefs: Clamp replicas_required to
> > replicas") in linux-next, I see a massive error occur when building for
> > ARCH=3Darm64 with both CONFIG_BCACHEFS_FS and CONFIG_LTO enabled, which=
 is
> > important because arm64 defines its own __READ_ONCE() with LTO enabled.
> > The error appears to be related to the minmax.h changes that went into
> > 6.7; I think it is specifically around commit d03eba99f5bf ("minmax:
> > allow min()/max()/clamp() if the arguments have the same signedness.").
> >
> > As far as I can tell, replicas_want and the metadata_replicas_required
> > member in struct bch_opts should have the same signedness, unless the
> > __READ_ONCE() macro is messing something up, which is kind of hard to
> > tell at this point...

The last line of that READ_ONCE() expansion looks dubious to me.
The result type is independent of 'atomic' and I suspect ?: counts
as an arithmetic operation and u8 gets promoted to int.

That would fail the old min() as well as the new one.
Is this code new? I can see it online in 6.8.4-rc4.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

