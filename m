Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C38C7EE2A
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 16:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbjEKQQt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238753AbjEKQQr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 12:16:47 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021042120
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 09:16:40 -0700 (PDT)
Date:   Thu, 11 May 2023 16:16:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1683821795; x=1684080995;
        bh=MN+F7xsDUKyihqmXNSYVmWW+TT1z5DRJGFbLAF5PwVQ=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=KV8fBoYpX4Lkt+5qNzplDpuBTX7ldL7fO7lOx6m+dCpkJHKoIFvJ7isy3lrY3LFp5
         MI2mBRbfMfxeEM2UHqdqnf8ItOcKRPwKmVJUwVuFtggarc0DotwuPtS93qagVSpue3
         Og8tP7BEUt6/XOrFNIDcu8xLgOzpgdbK4SfT5bltH18hOyxEROdE4gMzfXzXsLN4rh
         PA08H8c9ErYGIEF8IrFARDthH1Lh36f6b4LzdH1WcNaMSiDqqQx8jp+0rW2Fq8qv+5
         ynDtharyokExgveLioYXxzGyyAk0J4I6JUrVRQqehhp9ZoNTVV36qvFu+qGcrXjhY+
         XziGUP3cTyeQg==
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
From:   =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <U4SpqY6MGcSaFOCHP-pTC2oqyrv7dh2BAlR9xubt3iymLknSafueqtUuhj0UzZUw8YGGNjrbti9_G4cUTatBMlbkOuErR5Uxw2pXpvZnZ_g=@protonmail.com>
In-Reply-To: <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan> <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com> <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com> <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com> <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
Feedback-ID: 27884398:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wednesday, May 10th, 2023 at 05:10, TruongSinh Tran-Nguyen <i@truongsinh=
.pro> wrote:

> Hi Rust for Linux folks,
>=20
> I have another question. When working on user-space, I'm used to cargo
> dependency management, but I assume it's not possible when doing
> kernel development. Specifically, for the immediately next PR, I need
> to use these 2 crates (and their artifacts)
>=20
> `use bitfield::bitfield; use byteorder::{LittleEndian, ReadBytesExt};`
>=20
> Is there something similar in Rust part of kernel already
> (https://docs.kernel.org/core-api/packing.html# and
> https://man7.org/linux/man-pages/man3/htons.3.html respectively, may
> be) ? Or if not, is it normal to just copy-paste the needed code
> together our code?
>=20
> Kind regards,
> Sinh
>=20

For byteorder you can use the builtin {to,from}_{le,be,ne}_bytes and {from,=
to}_{be,le} methods. The former return and accepts a [u8; N] array where N =
is the size in bytes of the integer you called it on. The _be variants of t=
he later are equivalent to the htons family.

For bitfields if you have a struct definition with bitfields in a C header =
already, bindgen should generate a type with getters and setters for the in=
dividual fields as well as a constructor. See https://rust-lang.github.io/r=
ust-bindgen/using-bitfields.html If the type isn't defined on the C side I =
guess you could define it there as helper, but having a rust macro for this=
 like the bitfield crate provides is of course nicer.

Cheers,
Bjorn
