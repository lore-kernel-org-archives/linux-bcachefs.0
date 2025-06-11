Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F2519C560;
	Wed, 11 Jun 2025 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749675527; cv=none; b=GLmx0mQWsZwW7XEfrPGi1OKFVGAVjJzK9163be9WM7fjV6vnEgTeIXMFhpKaw91m5Ct5fEKosQohP8qRbWc734YETqxaGEZ4KtdRqqoaCBPhx3mY7zhLesgOu8E6SjxMd9B1aqd5QNlsk2GACw0MsosvxoZS95smyGiMVZ8fBKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749675527; c=relaxed/simple;
	bh=l500A57FKmUA6basbzhgby0D4IJxkWqk0v40QYvcDQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uG8sA/AoYpdCGo8TmvqJ9rYc0XdQXcPB2kA3yULsMMr/z2iMbPg1kyOOfg1d1Xh8Vtx5BGTHBH4oXxg8dOSlywau5w3YTjJWw+i0VoQKwUvHy3hwnQE15v65kwjxL5PYUomnCPnhRQ2rOjVfJgvxQcnGLncq1VsPzYq6t7AU/PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSRYRaE5; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSRYRaE5"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4a58e0b26c4so4432271cf.3;
        Wed, 11 Jun 2025 13:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749675524; x=1750280324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4aI7R+UyGh9Zrc1pgRa4pvEm4k9kJeDQxPpARq+cyI=;
        b=mSRYRaE5i3S+vgnwHn47dncrLNuRvwJ90qT+LyDdV4ZkumIX276pog8+iHq+gKJWQ0
         5MTrcYvHsr/KjUroktuynvw27wM6gbz3kBxHiuq29PX+ZZkI0ETZAkF6gRZAEktDdpEb
         ij0pdvs9ymsP1Kvkm8ezBlsBcAHAto+F9exrL6DQksVr8MElrnbT/jUtNxvuSVup575Q
         ptfs9d0p60uVuaNX+WPbH5/2HNBRKIYb2AQ6sbkF4Ag2StAy3ZfI+uh8U9rkwZXouoDj
         nNg5EUNvx7bQm2OKSvHGv+fu1anffF6DU1HqhulCuP/7NFyBmC4IDnoMm7PyV459dJKR
         M5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749675524; x=1750280324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4aI7R+UyGh9Zrc1pgRa4pvEm4k9kJeDQxPpARq+cyI=;
        b=MdUwdnRR0hRcEH0GaRCNwb2F9xtGyjL0oyUFik43KVsbl+DBMx1wjUlJ0S6UPf0Xi5
         cx2j30d19qFMD3ihACsS8Z2rtV5rGVL2x1JlVJMR2XKZqmyuKqEpgkEnTB58n8GbIW9z
         rO/3j+VXKh/1ezYcwkOm7DwqwuCdFb2sbhEzcFFH0RppGlgp2WXmPsPkcs5TD5/tTmnF
         CBOkv/5XXGd1MQ4K7jWrx+DZp484r/NyHMYSwyEx1dYoiwTEd37lWWui5KhGOuSpvXSm
         l1wmCaOWOAC/iwXCU+KBalsHtAqB3jVCxIlt59F7ys3nl9y/qsGscLAQ/S0d5dFnKgwL
         6Yvw==
X-Forwarded-Encrypted: i=1; AJvYcCV01WJbor5ovP7jVVGJyzLEBycjQXbgvFDynsRcJRwOZQxuWUib6N3w+RRw5v8nSfS2HxDfpredV1NqvvBP@vger.kernel.org, AJvYcCW4LKXuXOdZSXokjUxkUCuuJjFKwdeq+OuhgbEy5EihCkqozNof0HpTOWuPCsoO1HJK3R5pGTOR7JtRYKXNXw==@vger.kernel.org, AJvYcCXad6LXHKox1AXRO0vSzOScC9ZyesOCde2UiZgAFeP2aSHaZDX2BQEWlAS+ENnfKCKp6Jsy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3hXpTDwo6LKfnS1XUaFpvWoBeLj5EYU18B90PbL3cBxv5q2/W
	4kf7ivTq1CMsLPhvM52oHChRiH6b3xeOhknKkJZL/qKZhtw3ONWG+3Tg
X-Gm-Gg: ASbGncsy+bNM+7nVTv+A7f0RImiT3Irw9BN1ItHk40r1kUbVQUPGNhbqiYUbbHE8QrJ
	HkzLqOHdS4C7fDn8ujwvvdZr8FYTPRmchkNqixC8J/ESwRIRGE5nhrcqiulY8z7Q09r6onTFyma
	zqRwl07Gt06ayTbVC0CHCSy4PEu5S8Uu8NHhSrKU8rdtxc8Rl7A8RiDPFILPQH9vwS4LbG/JkYX
	/rNvyR3Z/2wmzFWhCpFtSKLk0tm82hLxZUFtVvUMjTYhfPdqigsgPWFsQR2znvTqZxSQo9B2UTu
	7YWqU4y2b1qP1kRY0AgW8tYsPA1eNS3CSNipnLIx0euzUfjqk2bNoyBrDz08OlwH2sOZe9t+WEc
	em34d6PnzRA0BhVeL3/tILSknyIv0sdrb1KneHFEfJKFvYH835h2mWQo9Q4OT6LQ=
X-Google-Smtp-Source: AGHT+IHnnYuz344+rYjm3r+tUZJMsarIkOY2wup0Sq5q8bbwY63IA60GVtuhfILeLAh4/ypy1VISmQ==
X-Received: by 2002:a05:622a:191c:b0:476:74de:81e2 with SMTP id d75a77b69052e-4a7229b5f4bmr20806861cf.43.1749675524405;
        Wed, 11 Jun 2025 13:58:44 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7248ed79dsm922611cf.77.2025.06.11.13.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 13:58:43 -0700 (PDT)
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 627411200043;
	Wed, 11 Jun 2025 16:58:43 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 11 Jun 2025 16:58:43 -0400
X-ME-Sender: <xms:A-5JaOvh3qEOCVnlrc8KSW5BT1FLpkHGprS1vD3oaztvP5IsHcIgyw>
    <xme:A-5JaDdveYG54ux4tMOUPFCtPtm_KoCCMI6ZJ5ryZ6JbJd9UMyNk61MQjGbMDmCwf
    H-VRK3L9lnRKfBeRQ>
X-ME-Received: <xmr:A-5JaJwctGrWC9QqLK5kMXIQ-ifBPaBbSW7kHiBKOIDYdtemObIiZNNoYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugddufedvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvf
    evuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceo
    sghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeevgf
    dvheehleejieeujeehffdugfefgedvffdvueehgeekkeekiedvkeelvedvhfenucffohhm
    rghinhepshihiihkrghllhgvrhdrrghpphhsphhothdrtghomhenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgr
    uhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsoh
    hquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghr
    tghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehshiiisghoth
    dokedtvgehugeifhegheeffhdugegrheeffeekfegrsehshiiikhgrlhhlvghrrdgrphhp
    shhpohhtmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehjohhshhesjhhoshhhthhrihhplhgvthht
    rdhorhhgpdhrtghpthhtohepkhgvnhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidrug
    gvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgt
    phhtthhopehprghulhhmtghksehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrtghuse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:A-5JaJPCFy25SxUpX_vBJQdQKM3WYfNA6ZoMC5rvYuLbwwm0HTXSAQ>
    <xmx:A-5JaO-utaFdMlq9mAdoO0dKRnM92EicE08mQHEdz61bgENcftuSug>
    <xmx:A-5JaBXSwByqB9m_z4RbJv_pfsFuYj3IprRwP-_2yzDb5eVvDQR5zA>
    <xmx:A-5JaHfi0c5YkvHfBicbCpIuHHd-o5VZTPolnEQ5Ym2CXmWdNQavuA>
    <xmx:A-5JaIcjOaHT1nHotFTYbNs6pJqjkZll74a609UT0Wuc7oZjJ1q-xTRh>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Jun 2025 16:58:42 -0400 (EDT)
Date: Wed, 11 Jun 2025 13:58:42 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	paulmck@kernel.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEnuAp5w6QSoSu_M@tardis.local>
References: <aEnVuzK7VhGSizWj@pc636>
 <6849df90.a70a0220.cc01e.058d.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6849df90.a70a0220.cc01e.058d.GAE@google.com>

On Wed, Jun 11, 2025 at 12:57:04PM -0700, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> Tested-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         488ef356 KEYS: Invert FINAL_PUT bit
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=129a660c580000

Is there a way to see the whole console output? If Ulad's patch fixes
the exact issue, we should be able to see a WARN_ON_ONCE() triggered.

Regards,
Boqun

> kernel config:  https://syzkaller.appspot.com/x/.config?x=713d218acd33d94
> dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=170e460c580000
> 
> Note: testing is done by a robot and is best-effort only.
> 
