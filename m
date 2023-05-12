Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD77C77B75
	for <linux-bcachefs@archiver.kernel.org>; Fri, 12 May 2023 04:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbjELESS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 12 May 2023 00:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjELESR (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 12 May 2023 00:18:17 -0400
Received: from out-30.mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E851FF7
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 May 2023 21:18:15 -0700 (PDT)
Date:   Fri, 12 May 2023 00:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683865094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NiQ1GTCfwkWMdplG3qArgYrAlr515St2shp4EUM3owU=;
        b=iHj6AK9y6WnaIuOjTn7bOCthF66M3Flcts86O4VxVupt8eQSWQOoKQaC51WfCtklT1tjMN
        ssq1n8t8L1yax8ch8xdLAUdlnrjdtmQKB4MqdhF6xx5HtLQF2M3hhKBnmlMDlfiD45zexu
        wNY6qGQUANyjBPUR5tpRLbG1RH053io=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        rust-for-linux@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        linux-bcachefs@vger.kernel.org, Andreas Hindborg <nmi@metaspace.dk>
Subject: Re: [PATCH] chore(util): minimal Rust build example
Message-ID: <ZF2+Ah5koJEdq4A1@moria.home.lan>
References: <ZFqM8HOvlVn61VXs@moria.home.lan>
 <CANeycqq5xCUcjOeOfGAJCH1Tzd01-ALU3uqVJo-BvVX9HOK9wA@mail.gmail.com>
 <CAMy36z5VP_6atrxdOyXSO6G+R36vA8SuaWCDAui3Om3viogPkQ@mail.gmail.com>
 <CAMy36z6+RjgAfEYUxpOhS6vFmTter=cFa2CEorSnKR=qxkft=A@mail.gmail.com>
 <CANiq72nYq5vimbhvfyUj9ejOS487LCQBxkv+7Nt5yYJ2xW_U-A@mail.gmail.com>
 <CAMy36z7iofMAK4GkYaUjW27cSC4sg-QGooj93mTg8SOb0eXxfw@mail.gmail.com>
 <CANiq72kcVS=_07D-KDcb9cVByV886mf50ydqNsMvcrJ1myLOuA@mail.gmail.com>
 <CAMy36z710P4ZVW0z_Y=ZObLkpP3Jc837B0z4sTGoDUXCH+8MRw@mail.gmail.com>
 <ZF2zCUV45mYxSe4e@moria.home.lan>
 <CAMy36z6fiC4esHKjAiOaOp6=sAOCbiJXpJku+6_h26xGPs8kWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z6fiC4esHKjAiOaOp6=sAOCbiJXpJku+6_h26xGPs8kWA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, May 11, 2023 at 09:16:19PM -0700, TruongSinh Tran-Nguyen wrote:
> > This doesn't sound like a uapi question, it sounds more like - how do we
> > expose C interfaces from Rust?
> 
> No, I do mean UAPI, as exposing C interfaces from Rust (to be consumed
> by C code) is known. I'm interested in exposing Rust API (from kernel)
> to be consumed by user-space Rust code.

What's your use case?
