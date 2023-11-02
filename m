Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C4FC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 19:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjKBTLt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Nov 2023 15:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKBTLs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Nov 2023 15:11:48 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C35012D
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Nov 2023 12:11:43 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-419b53acc11so63061cf.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Nov 2023 12:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698952302; x=1699557102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIakNXnRvrAUTek4TZG2B/UaefFH7tlKdSQhJTCcSHo=;
        b=yHMv1aum06LNrNZJ2niqD8OXm1glgT8Yqdi67lwKWFhfulSVOKrtnJ593zKzjSD4Lt
         MJfYnyBI1TmQAvpbC8hAHbBaAfp9MbXSLyDkozlmPDXdrSp77FAoaeL12RhcMxEk/BeQ
         M1rEpNsbW+4QO0RAyxFEOtqPrG92AfnspmabZ+VaxSq3iXpjFlqjxqnh6iI7WWM8UDz3
         hxtBa6YolglnWc6eCaqhU6n4W22P3G1D0OfgEvILlzMBj5iN2aobboAS5ZKeCxaDxKfv
         a0h4akvrTrQeqKuA7oQ2lVk6ExE496nQK23gSyOnubJj9dlJvs5ME5F0UcnVMnE1wwDt
         EyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698952302; x=1699557102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIakNXnRvrAUTek4TZG2B/UaefFH7tlKdSQhJTCcSHo=;
        b=hOQcLWLDiTqiE2H48PY01i1A3WCnNQ23vk22PGLzKE78CqbMq13+suIn7bFfJEHI7w
         skW3Mi9c0R6pn6z4bP5ARTvk7rngfQLR9vX7cuNxsa3Ud5x9G/ouiJ/TluMqVuedXXmU
         nQoIAskWL9ACbNKUNLNfkwQMtixeLeSR4cFfcY4EFCRfFh+Ez+jZ6IwUP3tpUZcqv1E4
         Z/wwho4zeAoBelNOGijeYC+82hFuGPuRSdbjwSgXDjUSEFCMPb4vbKBDrxwapP2gYeFD
         hVGILyxrLwHSQPbxzAycIoXqRnaczZ5Sv1m4Dds7GSeCYUi3dWDNnELkjSSRA9EOZILA
         6dhg==
X-Gm-Message-State: AOJu0YxAuiVWinNvMmyrppUWyky82hhjhrrk1IWe4dObIOpvBeYvjF+u
        WveY2zh2WAnF2Wp+cT4K/kyOx8x2n3b3FD17k0W/fF4u7R8D/rFhAQ4=
X-Google-Smtp-Source: AGHT+IGHbB6XsWDAQ+U7Ciz5e7YEltYGiO4gBjI2AUDr6sGgzw5IJwgfAuK9xxJXB8SzPOsz2nYa0IbY6e14u28NYEg=
X-Received: by 2002:ac8:4418:0:b0:41e:50ed:eb3b with SMTP id
 j24-20020ac84418000000b0041e50edeb3bmr272192qtn.8.1698952302088; Thu, 02 Nov
 2023 12:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAMT0RQRwBLBBp7ufmk3mrAaVAQxPKxiGEK5t+qvE+ftRnfyvmA@mail.gmail.com>
 <20231102144102.o5vfyhq6x2nhm7x3@moria.home.lan>
In-Reply-To: <20231102144102.o5vfyhq6x2nhm7x3@moria.home.lan>
From:   Hannu Krosing <hannuk@google.com>
Date:   Thu, 2 Nov 2023 20:11:29 +0100
Message-ID: <CAMT0RQSdLXvtXT_SYxDxjm4EQcTSBGWx35kuccCa69-nxxJeQg@mail.gmail.com>
Subject: Re: A question on bcachefs as a Cluster File System
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

What parts make it hard to use it as the basis for a CFS ?

By Shared Nothing do you mean some kind of log replay in a "mirror" filesys=
tem ?



On Thu, Nov 2, 2023 at 3:41=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Thu, Nov 02, 2023 at 01:48:25PM +0100, Hannu Krosing wrote:
> > What is the current thinking around using bacachefs as a cluster file
> > system (CFS)?
> >
> > By CFS I mean a file system which can be mounted concurrently from
> > many hosts or VMs.
> >
> > At high level it looks like it should be something quite easy to
> > accommodate, bcachefs having grown out of caching work and the main
> > difference between CFS and non-cluster FS being the ability to
> > guarantee cache coherency.
> >
> > So what are your thoughts on this, assuming that bcachefs is runnning
> > on a storage that is already available for all the hosts/VMs, what is
> > missing and how hard would it be to get there ?
> >
> > I did not find anything about CFS support in the
> > https://bcachefs.org/FAQ/ or other pages.
>
> No, bcachefs would not be a good basis for a traditional shared storage
> cluster filesystem.
>
> Shared nothing, OTOH...
