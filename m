Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFCA1C001E0
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Aug 2023 18:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjHJSJy (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjHJSJw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Aug 2023 14:09:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A58E48
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 11:09:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99d6d5054bcso153426866b.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691690990; x=1692295790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CdVO7LGdqPVywscLfXnXC7vbQR6Oxa8Ot+Ua+mHkMYE=;
        b=Ea7sNbAxq5l52YuA5/kkvqgTynB0iI2IpGjDlcwSF/cyvMuRZtTmChqyQ42aC5y+5L
         OsNhk0ed8ezMAkt0fJQdd6K5tooV+fMckUUl1X+dT88VSzioH0agUtlR/T8JFCUdFC12
         lp4osvVuqf7ZMo45ogvh5p1cNtT9YxtEj+w5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691690990; x=1692295790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CdVO7LGdqPVywscLfXnXC7vbQR6Oxa8Ot+Ua+mHkMYE=;
        b=j8CSYF/Sfe9z0Prj8OnB74uiCFCzoQki1Mly54XZ8E5nUQpeUGSJfDCjVj47S7fAO2
         PP8N1uO3J6bK6//5t+vpexh+MYnV3nm8uZOF7yz0hsvdQlYQf8Gj9mcmML2+ddMOnf3K
         KsabIU3gPjDnuTQsr3v72RkY96SU5V5acVBA1fz+//lF0aasHzBGAndF6twn9Up5sZPC
         0QmWTyzK47v2Df+lymufWzVaYxSelLZdEm/7E+9j5PFPNmZ29kfYFxN3UIbdzKyt6Paj
         Jp0n962oB8WNSF9hi4pBTn3wxyqkupYfthYHWrLdY6CQUfVetHv/9LpQzxRVUBr4JKd7
         KJ2Q==
X-Gm-Message-State: AOJu0Yyw3/fiFMhPB0JJ3/GipUmlZiQaqIJUQCA090PCixA3wHKxtkGt
        hn22PUxrpaNdsy4RZXIU3v5td7lZumAEC2wrTbr8qo1F
X-Google-Smtp-Source: AGHT+IGWQae6s+xPehDmhIuGOFRs9ATeBb0GM05QFDJziim/nICyd44G4fJPRUwd7eG/YStGW3n0xg==
X-Received: by 2002:a17:907:c16:b0:988:d841:7f90 with SMTP id ga22-20020a1709070c1600b00988d8417f90mr3503181ejc.27.1691690990416;
        Thu, 10 Aug 2023 11:09:50 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id l7-20020a1709066b8700b009737b8d47b6sm1226212ejr.203.2023.08.10.11.09.49
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 11:09:49 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so4791937a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 11:09:49 -0700 (PDT)
X-Received: by 2002:a05:6402:520a:b0:51e:5206:d69e with SMTP id
 s10-20020a056402520a00b0051e5206d69emr3555926edd.10.1691690989521; Thu, 10
 Aug 2023 11:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan> <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
 <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
 <20230810155453.6xz2k7f632jypqyz@moria.home.lan> <CAHk-=wie4U8hwRN+nYRwV4G51qXPJKr0DpjbxO1XSMZnPA_LTw@mail.gmail.com>
 <20230810180244.cx3vouaqtisklttn@moria.home.lan>
In-Reply-To: <20230810180244.cx3vouaqtisklttn@moria.home.lan>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Aug 2023 11:09:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh6R1z=6v+qJpe7qAZGNYZK1ZMs1+dhD7FahVywnMr1Uw@mail.gmail.com>
Message-ID: <CAHk-=wh6R1z=6v+qJpe7qAZGNYZK1ZMs1+dhD7FahVywnMr1Uw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, djwong@kernel.org,
        dchinner@redhat.com, sandeen@redhat.com, willy@infradead.org,
        josef@toxicpanda.com, tytso@mit.edu, bfoster@redhat.com,
        jack@suse.cz, andreas.gruenbacher@gmail.com, brauner@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, snitzer@kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 10 Aug 2023 at 11:02, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> When using sget() in the conventional way it's not possible for
> FMODE_EXCL to protect against concurrent opens scribbling over each
> other because we open the block device before checking if it's already
> mounted, and we expect that open to succeed.

So? Read-only operations. Don't write to anything until after you then
have verified your exclusive status.

If you think you need to be exclusive to other people opening the
device for other things, just stop expecting to control the whole
world.

                Linus
