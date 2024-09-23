Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0521946AA
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727118465; cv=none; b=pwEWVgnpvXZe0FRlL0Tiv+EOxNeh+DOv2W3wZTOb3LXeUUIvr0mKMExztrHJZKsxxgoCULW3yT20wwShHQo5jbrxcBjmWUbR9rZPydQNEMmTpq8k77SRcTVpe0YvHs3XZSRpRjxpyyrSBCPbN1IpSfIVWxbxQjNece/743KrBbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727118465; c=relaxed/simple;
	bh=6oA7gDJzUeZfHw/vFTOmEelPMtY95bHTlj5TQt3Oydc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SC8+SG11F0EluNniZLEl4AAunYO4GQj13pONoAqF5sVx4L3ASI2udrGLg7gVAtOwFHHnruZMw3liV3OxfbZzCYXZk0xPsJV5t2ZOZ6YtA4/sh2RtvS/9xiKOmq1dB9LY+kR04fJ+ml6FcfLpFnoidJcPYVu6gzovcZbxqBxiLZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fSb0V6Z+; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fSb0V6Z+"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53659867cbdso6526906e87.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 12:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727118462; x=1727723262; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FdJ3u8jesj1qGHjIV/QOFO/xQy5KMIpe78wId6CJClM=;
        b=fSb0V6Z+5CAymzLG/YbVjfXGwdHMAE2Idf1I6NOz35i4H/2YgO/PBATDvIAmdqTBay
         v00+0l8I6SoO/4ZSx1vn/yOxsLw3HCpmw+97+RX3JmikAEnaUnMGN+tSS/ROca4NQueW
         0Kheq3rVM7M0fC6OXTQ3hHSHmwxNEl4WtxjzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727118462; x=1727723262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdJ3u8jesj1qGHjIV/QOFO/xQy5KMIpe78wId6CJClM=;
        b=ifJp3Ke+Urox2MdAkr73m7T/b5Y3GNARabtAhO/ZLgs48fTSucuT+8lW4TkJDGjb5c
         YfdMbXslb6lOW+2sRkQMtemxhq7dsgGIkp6qm8A8EcT2ogjv6WKqj+QHH8mSHQJuwkF+
         jCjcybRwzrRt0hmx/IaUeJyFdyyOFW/UGOuqH2ztw3qA/Z9RZ+Swh0KABSklJtA7tcRt
         UuGb0ct01JLTSoMnQaZeZk29ot8/GmdkHU33F2JnZh76ZGoyMD9QbR3Wohy+1ugPW7Cm
         sNYnPqpzJXVzXhf+G5ksLARqPcQ27CBziJTXyMldHu8MxiwCNuIMjVoRc9uwnZ0c3o0e
         wb4w==
X-Gm-Message-State: AOJu0YywaDpVl/14/jqWmnpLk+jqXqM18pzIw0RydniD5TBFfOx11q8s
	wQFTwtLte1rbc3ghDvP9iJC25CztoemTA06o0XGjyT4W0wYZy0ghC9RHLpjk/8IHSunK3pfp+5I
	OGs4=
X-Google-Smtp-Source: AGHT+IF1io1FkGJMGMEJ/taWQa/ZqD/TDQfMC6/p7cZ0WYTFonZjpzB8yv+PXHlfWSjG6uBjjAXSUA==
X-Received: by 2002:a05:6512:280d:b0:533:4505:5b2a with SMTP id 2adb3069b0e04-536ac2f5b48mr8252940e87.28.1727118461576;
        Mon, 23 Sep 2024 12:07:41 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061096979sm1279676866b.18.2024.09.23.12.07.40
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 12:07:41 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-378c16a4d3eso5122052f8f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 12:07:40 -0700 (PDT)
X-Received: by 2002:a5d:5e0d:0:b0:37a:4713:3de5 with SMTP id
 ffacd0b85a97d-37a47133f2emr9049324f8f.26.1727118460522; Mon, 23 Sep 2024
 12:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm> <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
In-Reply-To: <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Sep 2024 12:07:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjEDDexH4DQdmzQMipPPABVoHmXBx_byHkWC3qUM3uamw@mail.gmail.com>
Message-ID: <CAHk-=wjEDDexH4DQdmzQMipPPABVoHmXBx_byHkWC3qUM3uamw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Sept 2024 at 10:18, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, 21 Sept 2024 at 12:28, Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > We're now using an rhashtable instead of the system inode hash table;
> > this is another significant performance improvement on multithreaded
> > metadata workloads, eliminating more lock contention.
>
> So I've pulled this, but I reacted to this issue - what is the load
> where the inode hash table is actually causing issues?

Oh, and I also only now noticed that a third of the commits are fairly
recent and from after the merge window even started.

Maybe there's a good reason for that, but it sure wasn't explained in
the pull request. Grr.

                 Linus
