Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D013EE14AA
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Sep 2023 23:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbjIFXe4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 19:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbjIFXe4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 19:34:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C4994
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 16:34:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5298e43bb67so638107a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 16:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694043291; x=1694648091; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qp8O0CMBmeOIHtiFssMdoCJLtqwjaGXGbc+VERwFhw0=;
        b=IK+AguMszVU36JObjXVWChd2sAiYpQ6kXc1qmGDRpaJqJK5roiEw8A3uXjavqGNgti
         nI+g5lTJf28a7/d9YyPSjSnBxbqzL/YPQiqz5ZXACXaQW1TSK17MdS483FP2RRnaT7n0
         3cZ8ouik27CityQgMS5RCXb8AwN2V1usLcISY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694043291; x=1694648091;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qp8O0CMBmeOIHtiFssMdoCJLtqwjaGXGbc+VERwFhw0=;
        b=Seb+BLBGYp44nYZm3iHqZZspowRP72ZJMt2ZhytOX4RdwZGZpqc1nwROrXsVEWnm6q
         5FDI2x80zlPAbkagKY2QmCxkzPPGm9GwpQNZyqMBY3KpIuLRSmJDuikO/L777K4VXDfL
         ztrfDFHt35oQlweoM9I9BQ35O9vQZ79bf6KJPiUv754fwfRvkR0hm31nrcZqvLgcv15c
         kwn+pcL/afEF1wmZOwW/bX2LH1ZUMXOHCBF7CrHSysx/BUhYZRvuDHPuHRUtCXs3r2D7
         0dfgXMwdUOaUg2xyJAsSIlC5qZFVX3bwBd/+Gf1x3yQXXEQF/DzPBwPXiJYrtd8G5Y7R
         Cc+A==
X-Gm-Message-State: AOJu0YyaAQazax6IDePoUR/6tJVyZnHNXwD9A/3VmXWSSEXXLle3ZTp+
        vlGltZ7Vge5e0Hahy7qTS931IQiO9yPuSxAfFNxSoZm5
X-Google-Smtp-Source: AGHT+IHMtOkLcOUYern/NKK5zi+ONhVyMRcbWhADeq7PbTrRVVUg31ztFEjCzkElDyg1WOCyXm7msA==
X-Received: by 2002:a05:6402:5188:b0:52e:4789:bee2 with SMTP id q8-20020a056402518800b0052e4789bee2mr1334538edd.6.1694043291093;
        Wed, 06 Sep 2023 16:34:51 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id d9-20020aa7d689000000b005256ae8494asm8981808edr.17.2023.09.06.16.34.50
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 16:34:50 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4c0so675183a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 16:34:50 -0700 (PDT)
X-Received: by 2002:a05:6402:4405:b0:52e:83d0:203e with SMTP id
 y5-20020a056402440500b0052e83d0203emr1287353eda.10.1694043289719; Wed, 06 Sep
 2023 16:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com>
 <CAHk-=whaiVhuO7W1tb8Yb-CuUHWn7bBnJ3bM7bvcQiEQwv_WrQ@mail.gmail.com>
 <CAHk-=wi6EAPRzYttb+qnZJuzinUnH9xXy-a1Y5kvx5Qs=6xDew@mail.gmail.com>
 <ZPj1WuwKKnvVEZnl@kernel.org> <20230906231354.GX14420@twin.jikos.cz>
In-Reply-To: <20230906231354.GX14420@twin.jikos.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Sep 2023 16:34:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+RRhqgmpNN=WMz-4kkkcyNF0-a6NpRvxH9DjSTy9Ccg@mail.gmail.com>
Message-ID: <CAHk-=wh+RRhqgmpNN=WMz-4kkkcyNF0-a6NpRvxH9DjSTy9Ccg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     dsterba@suse.cz
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 6 Sept 2023 at 16:20, David Sterba <dsterba@suse.cz> wrote:
>
>     I think I've always seen an int for enums, unless it was
> explicitly narrowed in the structure (:8) or by __packed attribute in
> the enum definition.

'int' is definitely the default (and traditional) behavior.

But exactly because enums can act very differently depending on
compiler options (and some of those may have different defaults on
different architectures), we should never ever have a bare 'enum' as
part of a structure in any UAPI.

In fact, having an enum as a bitfield is much better for that case.

Doing a quick grep shows that sadly people haven't realized that.

Now: using -fshort-enum can break a _lot_ of libraries exactly for
this kind of reason, so the kernel isn't unusual, and I don't know of
anybody who actually uses -fshort-enum. I'm mentioning -fshort-enum
not because it's likely to be used, but mainly because it's an easy
way to show some issues.

You can get very similar issues by just having unusual enum values.  Doing

   enum mynum { val = 0x80000000 };

does something special too.

I leave it to the reader to figure out, but as a hint it's basically
exactly the same issue as I was trying to show with my crazy
-fshort-enum example.

              Linus
