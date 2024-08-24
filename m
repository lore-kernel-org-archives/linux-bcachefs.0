Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB815E97
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 02:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724466960; cv=none; b=NwQlLvbjAbUfRjuJvNyfPiqW3urZXy2ehm7SIE+fKXwqI2n8AdyVVPF8YpP/pHcLj4WRSAF8/BdOh8U91jZLnXFT55Fg4TtQKpeepO3xsU/pmp6jek9KDizd0dFUKvLGQeg/PywD+iwwur4YAbNT9H4t+gAu/SB+tQ0Y7j6SbUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724466960; c=relaxed/simple;
	bh=fpOTYeaTgYEfTyZLe6LL9YNO65uUXscpke96JBbH5Yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uygSoVlEb1vCSsluHasjQA5fJhl+0LOLNJZOQ+FRG+5tt74nr+fVs3VZ82YBrjYn0ueX+Rzc3HTm9mth1mMHXYNv3tRu/Rq0bL182wbEiKhoaL597lnWFlD9QnauTEjUlB9/mLMaP3ue++58AqDwV1NsdNKA/6ruBDmTd/gmKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rpf+v7To; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rpf+v7To"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53345dcd377so3340374e87.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724466956; x=1725071756; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5iIZTNjIJCLen0zby3onx36YZi/MddADrcfReM+hGJ8=;
        b=Rpf+v7Tojz7M6zH4VKSvcAdHh1+fjaF0WZO73U0nj45nr4uMZjfkdOgXl6E5+ijjop
         PSs6bgkTXagKDyM32HIpUpXZXLFak9X+Wq7KIYHtRxZIUAosaJUykDuCttFv9mOugOaH
         EuJC6Wcs6XvnNUFTzjThkV5N1oAdBgdOAJsUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724466956; x=1725071756;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iIZTNjIJCLen0zby3onx36YZi/MddADrcfReM+hGJ8=;
        b=QDcBeUE8L3AqLvwX49NfSbwKxC2RkL1f6MqFy20kvzmZcbU8ED6/mUhLNpi3mpyeO0
         cMkAeT5jNzwZrkrpI6UfK1pWVjadUeCPVRL9Kgaq9p8QNpyo3hOOodFTC8CM94JxKXB9
         4a1JGUuwXCYKF+6fvaSJPUtryvK50WmcBpGAFWG6ciksEs6O+/dP0uS8CYoxddqfGyz4
         MITeReER6epcoLW0vtdEJWBdxoQbyX9uV3jVot671HenbpMZveslSmLLrlJIJ8paf/sS
         8wlVFXwTVrocuetuWbkzmHV1juKOenr1wKx/ugRz7N6D8aVFnINE3lPhLfj8BqZtTM/t
         Nh7g==
X-Gm-Message-State: AOJu0YyroR8dK8T1RiK4bzRiQf+2kfJrvMkTFjioAbxiIbKyfSwASK26
	6pp0PnKnvdZ57B0m2BXhlbBJrVxUrL8VyICkysq9OdVhjPpW+pv6dNpEiolnvkdlP73RBIgIF5N
	Q41zf2A==
X-Google-Smtp-Source: AGHT+IH6bibGENo92X4bHMo4WVe9l50M4Ew0NqGgKBaGte69K0kEDzuzvDa05/GEU8DZlELRgGClMQ==
X-Received: by 2002:a05:6512:3d20:b0:52e:bf53:1c2b with SMTP id 2adb3069b0e04-534387557dcmr2604595e87.12.1724466955746;
        Fri, 23 Aug 2024 19:35:55 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f436b97sm339877466b.101.2024.08.23.19.35.55
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 19:35:55 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa69dso2884901a12.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:35:55 -0700 (PDT)
X-Received: by 2002:a05:6402:3608:b0:5bb:9b22:68f4 with SMTP id
 4fb4d7f45d1cf-5c08917592bmr2570008a12.18.1724466954761; Fri, 23 Aug 2024
 19:35:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
 <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
 <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
 <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com> <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd>
In-Reply-To: <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Aug 2024 10:35:38 +0800
X-Gmail-Original-Message-ID: <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
Message-ID: <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Aug 2024 at 10:33, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> What is to be gained by holding back fixes, if we've got every reason to
> believe that the fixes are solid?

What is to be gained by having release rules and a stable development
environment? I wonder.

            Linus
