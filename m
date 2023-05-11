Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DD0C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 17:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbjEKRGH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 13:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbjEKRFy (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 13:05:54 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0FC19AF
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 10:05:52 -0700 (PDT)
Date:   Thu, 11 May 2023 17:05:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1683824748; x=1684083948;
        bh=2pI++1GZoqh4mnIPgH4KSlX7cIbDjh/8l9RSVdS9MT8=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=E77nwJn8eSMOIOO8NoGgoTP6c8A+eo3VQB2GuVtWeMfdPuXNMkuV4IEPulWbjEyhI
         /2XlBCAoEFd3S77W5L3Dph0d5z7jcGTf/RflFUafLd9z+F4FWSS+QxoMbQEkOCniyU
         /aJ0AG77JsLq7UpLxr77IMN8c0BlQFDQ+ohq02MpNr5spEs+HlnBw+C6ifjoQaC2LX
         Wmr9wjIcEMAEmi2XQuoe2FNRTatxfBdIWYt+l4iniVEbWsHjDzMskIVaG6faMLlPa3
         5DcnDIfBqum6XldgFXJ6nuL03Hvvo132v8dALOF16zOD26vY5odM99XX2373kQ3Ciq
         0srdQxV8fAfKA==
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
From:   =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <2rQHLC94NzAwtKaPbGMnzol4xE6cJ5i4FUx_MoK417SYnui2nVsx3ijtx8okVD14AY3SkwF5CEsJuckE1ydZXyXCZBOTECT3osPjb3xAAaQ=@protonmail.com>
In-Reply-To: <CAMy36z7_UVZT03svBPVQpQyYdhWqFFmVokY7K+iy7MkDtbvAww@mail.gmail.com>
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan> <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com> <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com> <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com> <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com> <U4SpqY6MGcSaFOCHP-pTC2oqyrv7dh2BAlR9xubt3iymLknSafueqtUuhj0UzZUw8YGGNjrbti9_G4cUTatBMlbkOuErR5Uxw2pXpvZnZ_g=@protonmail.com> <CAMy36z7_UVZT03svBPVQpQyYdhWqFFmVokY7K+iy7MkDtbvAww@mail.gmail.com>
Feedback-ID: 27884398:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thursday, May 11th, 2023 at 18:46, TruongSinh Tran-Nguyen <i@truongsinh.=
pro> wrote:

> Hi Bj=C3=B6rn,
>=20
> Thanks for the help. About bitfields, we might consider using bindgen
> for now. However, in the future, if we have a rust-only module (no C
> code), it would no longer be an option. If I understand correctly,
> there is currently no similar macro like the bitfield crate provides,

Correct

> and thus one of the other options (if the license permits), is to copy
> the macros code directly to the module. Is that correct?

I think you will have to vendor the bitfield crate into a separate file and=
 add an SPDX-License-Identifier header with the license of the crate. Given=
 how small this specific crate is, I think it would be ok to add it to the =
kernel crate. If it was bigger it would likely have to be a separate crate.

>=20
> Kind regards,
> Sinh

Cheers,
Bjorn
