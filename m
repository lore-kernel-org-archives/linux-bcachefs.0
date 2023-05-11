Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9980C77B7F
	for <linux-bcachefs@archiver.kernel.org>; Thu, 11 May 2023 23:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbjEKXKq (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 11 May 2023 19:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239223AbjEKXKo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 11 May 2023 19:10:44 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760CA40DD
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 16:10:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-307664010fdso8529441f8f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 16:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=truongsinh.pro; s=google; t=1683846642; x=1686438642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WPG4a6X4h+5DWEWYShnnXPeem/HjObGPA6H/eKogG2M=;
        b=BIOoBIEI149cdBcnCxZTmKR+LlC63ppi6ow1399WRIFRxnPRn8mTMw4vxL+q6QUrXw
         2I/lWsHwD5xjD0BrDzgBkT37w2Qow3W8V0DqSnu6qTpsuSQff9uygcfoQHQbXSUDnJRL
         b/4EILJYk0IMSHU9AyXuWzOqfENk9ldxsThM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683846642; x=1686438642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPG4a6X4h+5DWEWYShnnXPeem/HjObGPA6H/eKogG2M=;
        b=PKzEkuWKqe6UzamReuP5fX4SMw/j9Eu6ioPQB7M41dxXJMKtVidAuTCHAke4jdSU3R
         /mU8qvCTrbgM85ygslBiFY3yVyA40ZThIB55gwJONidsJJkhWM7c3lXpkplsX06W5AZF
         31bytAF4FcJRNYMW5v/4GaG1UYunQlHFz1Y+aaJFb8ujvabkf+JJ7cDN+vwl6VnzxHjd
         WHF6omaQtrNax7kdzt1HsP6mTxTRLaxPYWeyrDjKa1vKgZpfi1ElQPbmZh8A2lwr+PbN
         tqVrRpvuByLu6Vo6RAMQbvIpXpYrZ+2q2MAll+O5Yq9+YiGuozjBUBhOLw448/GFxsWp
         m+8A==
X-Gm-Message-State: AC+VfDwv4M7Z7J5nZohCax1JUIzemPAn9Q7xwIg3k4xTqRd7as4DYnjM
        DMbn2GrJXkuWY+WXnAYsxpdQwskI+60GFePaWwmbdA==
X-Google-Smtp-Source: ACHHUZ41RLvA9B+2b9D4/cmHDvx+72agJVX1IMB8cSApYesY6e6Vcll5jR06Zk1QTGpH+VFSa0FwWwC286l1X3VTG1Q=
X-Received: by 2002:a5d:46c7:0:b0:307:a530:573e with SMTP id
 g7-20020a5d46c7000000b00307a530573emr7308710wrs.71.1683846641779; Thu, 11 May
 2023 16:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230503065354.19071-1-i@truongsinh.pro> <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
 <ZFqM8HOvlVn61VXs@moria.home.lan> <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <U4SpqY6MGcSaFOCHP-pTC2oqyrv7dh2BAlR9xubt3iymLknSafueqtUuhj0UzZUw8YGGNjrbti9_G4cUTatBMlbkOuErR5Uxw2pXpvZnZ_g=@protonmail.com>
 <CAMy36z7_UVZT03svBPVQpQyYdhWqFFmVokY7K+iy7MkDtbvAww@mail.gmail.com> <2rQHLC94NzAwtKaPbGMnzol4xE6cJ5i4FUx_MoK417SYnui2nVsx3ijtx8okVD14AY3SkwF5CEsJuckE1ydZXyXCZBOTECT3osPjb3xAAaQ=@protonmail.com>
In-Reply-To: <2rQHLC94NzAwtKaPbGMnzol4xE6cJ5i4FUx_MoK417SYnui2nVsx3ijtx8okVD14AY3SkwF5CEsJuckE1ydZXyXCZBOTECT3osPjb3xAAaQ=@protonmail.com>
From:   TruongSinh Tran-Nguyen <i@truongsinh.pro>
Date:   Thu, 11 May 2023 16:10:30 -0700
Message-ID: <CAMy36z46EQYOGj8h0kHkEd8KYKnqZbUePe8JAk+a-0GJRQeK5w@mail.gmail.com>
Subject: Re: [PATCH] chore(util): minimal Rust build example
To:     =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc:     rust-for-linux@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

> I think you will have to vendor the bitfield crate into a separate file
> and add an SPDX-License-Identifier header with the license of the crate

I just send and patch to rust-for-linux@vger.kernel.org to include
bitfield macro into kernel crate.

Kind regards,
Sinh

TruongSinh Tran-Nguyen, PMI-ACP, PSM III, PSPO III

Tech Visionary, Craftsman, Coach and Investor

+1-6127-TR-SINH (+1-6127-87-7464) | @truongsinhtn

Find me on LinkedIn | Twitter | Github | StackOverflow

IBAN: LT76 3250 0264 6898 1177 | BIC: REVOLT21

Currently Reading
