Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCBCEEB5
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724468297; cv=none; b=dS0/OdYZT5XrDB2x2h5EV+eEpsphhaqlhMK4UV5dGyuPa+C35SqXv4QiTmTRD41DMj01Kmvs+RvCInfOBQm1uhaciGgGTRk/A7EJKR0jrZJH/vHIKBnNt8Ip60sW4rRQXi7lMWY2tACeCHHVBIyeOlEMi6auCbVM1lBxiDI1S0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724468297; c=relaxed/simple;
	bh=Hezca5d/Hiw2dSGl+lfWfGmJ5GwuSrZGZxIfhqwIlv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z/6iHmYeeRiXgrlvW0D73xcDDf5nlja6E2Kt6EuWl3o7p/xKTqbCpzcoT9IQ2uX3Xl7iqnmYoaf0NnaXReHJYOqH1zzE4ndxSxem0mW12/ENjeEaQNYyMpUPSIfMJJPX8/vUDA1pltaNcvSP4d6KnPpagjLxFmppfiugM/8c9D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b9/Z5YUu; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b9/Z5YUu"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-533461323cdso2970764e87.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724468293; x=1725073093; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0zedOl8uvkVp44rXL8uYLdQqyjd2Jc+tYGlkUMKlkF8=;
        b=b9/Z5YUuffySd9Ql9bADiNJ7HTGCunMWIPzYBH9egPB1VHKdS/hTkX3NVpWmhkFK4Z
         b9yYCYWVsi85KGrQQS0A+AMd9FELsInydhP7vvaKwPMRDorbX1krG5ztpBL9dUYw0w3A
         hKr/zmQ5X25PCFewVEKHoOVItoNWdDkYFhicc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724468293; x=1725073093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0zedOl8uvkVp44rXL8uYLdQqyjd2Jc+tYGlkUMKlkF8=;
        b=GyDSSNcxF8/UImC4UozHy6R0oRhPJYg9Dj2SQLS6f1Tryq4L8y8ghb1AyqdIjr/g4w
         DjWJAWuYAPdf3eycNYmk1EPc29CbcHtf5+3hCrt/Q1XC81ajMKkN7cas9hRQnpTgsTEl
         kkufB4S1Ioh7/GJhLfB1CQy3yXDBh6nA2DVRkzYtBmwNZyZJ4c+3dDkQ1WyyUu9iquRt
         KA6X9t8zm+ewi0+Nzrnm49XrHO+nSgek6R60khnwlMSJFVg/6oNR7qt3/uL/qaqtnm3p
         yjd6eneuuaU+obrgZExB7NW9e6z/x/asBJWEkzuXN2QPULJaFG70VcjzoM5I5z22ZIaO
         miZA==
X-Gm-Message-State: AOJu0Yz0hQVXLmV6WPcYD5goarJ53cGyJl2lurODZezajjq+VhkJeeez
	FfRNACaYgwGTDnahhGpPnvYLFXVhVUKkcrHnlHYyRwmvGUXUfLnENfQh1iW6oGR6bpGypY+ODmG
	wFgCcPw==
X-Google-Smtp-Source: AGHT+IGjb9EqOfdsbtlrM+6qY1tUYJlrZ+KAckH13RZaOl33v3oG/F3UIvNHQv0koVXYnlzrWmOofw==
X-Received: by 2002:a05:6512:159d:b0:52c:e1cd:39be with SMTP id 2adb3069b0e04-5343882db6amr2489346e87.8.1724468293113;
        Fri, 23 Aug 2024 19:58:13 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5334ea59308sm714052e87.141.2024.08.23.19.58.12
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 19:58:12 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f40a1a2c1aso20034171fa.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:58:12 -0700 (PDT)
X-Received: by 2002:a05:651c:b21:b0:2ef:2bb4:2ea1 with SMTP id
 38308e7fff4ca-2f4f5728ed4mr31688981fa.4.1724468292020; Fri, 23 Aug 2024
 19:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
 <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
 <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
 <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com>
 <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd>
 <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com> <wdxl2l4h2k3ady73fb4wiyzhmfoszeelmr2vs5h36xz3nl665s@n4qzgzsdekrg>
In-Reply-To: <wdxl2l4h2k3ady73fb4wiyzhmfoszeelmr2vs5h36xz3nl665s@n4qzgzsdekrg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Aug 2024 10:57:55 +0800
X-Gmail-Original-Message-ID: <CAHk-=wjwn-YAJpSNo57+BB10fZjsG6OYuoL0XToaYwyz4fi1MA@mail.gmail.com>
Message-ID: <CAHk-=wjwn-YAJpSNo57+BB10fZjsG6OYuoL0XToaYwyz4fi1MA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Aug 2024 at 10:48, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Sure, which is why I'm not sending you anything here that isn't a fix
> for a real issue.

Kent, bugs happen.

The number of bugs that happen in "bug fixes" is in fact quite high.
You should see the stable tree discussions when people get heated
about the regressions introduced by fixes.

This is, for example, why stable has the rule of fixes being small
(which does get violated, but it is at least a goal: "It cannot be
bigger than 100 lines, with context"), because small fixes are easier
to think about and hopefully they have fewer problems of their own.

It's also why my "development happens before the merge window" rule exists.

If you have to do development to fix an old problem, it's for the next
merge window. Exactly because new bugs happen. We want _stability_.

The fixes after the merge window are supposed to be fixes for
regressions, not "oh, I noticed a long-standing problem, and now I'm
fixing that".

But obviously the same kind of logic as for stable trees apply: if
it's a small obvious fix that would be stable material *anyway*, then
there is no reason to wait for the next release and then just put it
in the stable pile.

So I do end up taking small fixes, because at that point it is indeed
a "it wouldn't help to wait" situation.

But your pull requests haven't been "small fixes". And I admit, I've
let it slide. You never saw the last pull request, when I sighed, did
a "git fetch", and went through every commit just to see. And then did
the pull for real.

This time I did the same. And came to the conclusion that no, this was
not a series of small fixes any more.

             Linus
