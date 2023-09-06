Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF00DEE14A9
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Sep 2023 23:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbjIFXRS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbjIFXRS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 19:17:18 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C463A19AE
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 16:17:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99c1d03e124so31458566b.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 16:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694042232; x=1694647032; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=amaeJ0Fab/jVgSejYsWbzXhmle5m64ntHUW0zCfkNPo=;
        b=aPEgXuqR2GjFwgfvv7+ENSWuVIlXahEdbPIOvD3wA6UqUAncEeyeKpTYSvGeqwW27g
         aHz1Ri1vsOAqEgoB3WwCMrhDpkS5JOyaPwIESMhCqIpLKxPDofQjV8iaZtIGrmhzITFF
         VxKcPbYWdnJSqKC5icqa1HEiZwR6K43DJcPLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694042232; x=1694647032;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amaeJ0Fab/jVgSejYsWbzXhmle5m64ntHUW0zCfkNPo=;
        b=DwG8nBg96wwTBhNIXKTtqyVVJcchJLew48RJl7yn3hin5gXAIpH/1gh3BnVErC1AuN
         xDuXLPFKihtZB7FQgs5EjGvKPniqmd4LUlRRYmHGcWZoDzETbDYlMJB5UoBSE4jLnVwP
         jmf1YMqNrjE9dhlpeOdOShOWQQ8CgxVO9l72wuO2pAQay6bz88wJ/iaWw+pXt7Zk2dcp
         SNBHYfHj5wbmtJzAXhQ5bZteGZkNddN/DQu2FxMC+LJ5PhqFblgo72qsPMNKR1uiOFLP
         U7+LY7drXbQII4b0uWV4oR/dIlfpfS+tfjStty1dbFA+3PU5oGrDhiWVCFQetCCYBsV+
         /xAA==
X-Gm-Message-State: AOJu0YzoBs41ejMX3kBIkpvq33Y6RwY2MvLmBionJIWKBRh9A0yTDd/f
        m13kcCvJQ9rpqKhCw0bBjD4rYe+nOwZfUrIU+SmzveGH
X-Google-Smtp-Source: AGHT+IGXtDiXoldWcncWypV80BBY7Lrh5q6o7TAi5nUBmQD8udBG1vyL0WWAQYqBOcci6QvrDMvGwQ==
X-Received: by 2002:a17:906:214:b0:9a1:ce57:8e47 with SMTP id 20-20020a170906021400b009a1ce578e47mr3687706ejd.68.1694042231986;
        Wed, 06 Sep 2023 16:17:11 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id g23-20020a170906869700b0099cc1ffd8f5sm9495116ejx.53.2023.09.06.16.17.10
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 16:17:10 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31c63cd4ec2so384905f8f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 16:17:10 -0700 (PDT)
X-Received: by 2002:a05:6000:1cc9:b0:31d:d977:4e3d with SMTP id
 bf9-20020a0560001cc900b0031dd9774e3dmr3263064wrb.19.1694042229754; Wed, 06
 Sep 2023 16:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
 <CAHk-=whaiVhuO7W1tb8Yb-CuUHWn7bBnJ3bM7bvcQiEQwv_WrQ@mail.gmail.com>
 <CAHk-=wi6EAPRzYttb+qnZJuzinUnH9xXy-a1Y5kvx5Qs=6xDew@mail.gmail.com> <ZPj1WuwKKnvVEZnl@kernel.org>
In-Reply-To: <ZPj1WuwKKnvVEZnl@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Sep 2023 16:16:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiy=JOAWvSLwPq-jHPBfq8EX5NjVkEoh+RUMZbVn+GuOg@mail.gmail.com>
Message-ID: <CAHk-=wiy=JOAWvSLwPq-jHPBfq8EX5NjVkEoh+RUMZbVn+GuOg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 6 Sept 2023 at 14:55, Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
>
> > I don't think gcc ever uses less than that (ie while a six_lock_type
> > could fit in two bits, it's still going to be considered at least a
> > 8-bit value in practice).
>
> There are some cases where people stuff the enum into a bitfield, but
> no, no simple type.

Note that I am talking about the types gcc uses natively.

To show what I'm talking about, build this (silly) code that has some
of the same enum types that bcachefs has:

    #include <stdio.h>

    enum enum1 {
        val1 = 0,
        val2 = 1,
        val3 = 2,
    };

    enum enum2 {
        num1 = -1,
        num2 = 0,
        num3 = 1,
        num4 = 2,
    };

    int main(int argc, char **argv)
    {
        printf("%d %d (%zu %zu)\n",
                (enum enum1) num1,
                (enum enum1) num1 == num1,
                sizeof(enum enum1),
                sizeof(enum enum2));
        return 0;
    }

and run it. On x86 with no special options, you should get something like this:

    -1 1 (4 4)

ie both types have a four-byte size, and casting 'num1' to 'enum
enum1' will in fact give you back -1, and will then compare equal to
num1 in the end.

Because both types are in practice just 'int'.

But now do the same with -fshort-enums, and you instead get

    255 0 (1 1)

because both types are just a single byte, and casting 'num1' to 'enum
enum1' will in fact result in 255 (because it's an _unsigned_ type),
and then comparing with the original num1 value will no longer compare
equal.

(But casting it then further back to 'enum enum2' will in fact result
in -1 again, because you're effectively casting it back to 'signed
char', and then 255 and -1 are in fact the same in that type).

End result: you can get some really unexpected behavior if you cast
enums to other types.

Which is, of course, exactly why the compiler is warning about the
comparison and about passing in the wrong type of enum.

Sadly, the compiler doesn't warn about the cast, so you can hide all
of this by just adding casts. That doesn't make it *right*, of course.

              Linus
