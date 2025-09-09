Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37529C326
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Sep 2025 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757412725; cv=none; b=ugPR2FxoPZSiuc1jD+aW3pgOub/Twomy87hshxW5shWzwBJYwZ83V6hZKO7pUHfFAO6zW6wINIWYetrGQ7+autIeVsVmdHm4MF/Ub81pFQSybtr5xKufDXxWFC+fsgj4VCIO+7PBF6at347vX4T4FMTFUvhXgAL9nSD5XbrSpNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757412725; c=relaxed/simple;
	bh=932mIFgivKfhOi4TgO4xe7Dbk1HS5EyWyGGgF47Q53A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HE+UcuPFJRiD3VRa9sIJ9Ms0SQ/APVm9Uz2IV5TJsY+YQTdrDJZNI7PDOoUq/3I85/pZKIpmyZPE41HnOXYsIvOe7B5LJXU580yhwh8v/4RFZ++eHtLg5Sv0ZZ6ce5p1A3aAbKOepChHLQz/tXWT4D9EXgyIbmRP2jWSM4RWO3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ebPceX+I; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ebPceX+I"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-336dc57f562so47303031fa.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 Sep 2025 03:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757412721; x=1758017521; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=932mIFgivKfhOi4TgO4xe7Dbk1HS5EyWyGGgF47Q53A=;
        b=ebPceX+IPqCjI9JuBUAbH2xXuHvhnJbxz8oe7TRlR2wqm03Q8xQRql2B6yt6IODfY8
         S0DK6z9clQBQEX6kAHyDYUGSV/o2ryNCpfqVw5GgI/w8UQg6izM7VSJeItR7fX8HUB+E
         CC+1KHN6GGiBSDZS+mcVSqAJLt3oCTPLqkvXIq0juLRfP6EUa5do1P9rF7CdM7o4sFwM
         D+C+H44MreX6aGfpQgeK9CuT+MLruXfSko95YmCCWgtUnLg/2QVBLzQCEj7u6wFCXmUq
         P/lmvUj5EUlm53mArKkz3pFmMdb04aLmezVvCFF8AFDsEt7reASB9W7yKE7ywnfazAIV
         n9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412721; x=1758017521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=932mIFgivKfhOi4TgO4xe7Dbk1HS5EyWyGGgF47Q53A=;
        b=psfquyX66THTf2SRM+7cbmc+GqaoxCnU6KTu6w8YYN09xUIkIBAWlzsAbAtRD4W93S
         rcEKH76YyXfSIAr9HG+7TXM5Rzbhx9kVYCcXNxbE0e0wIRFKNz6sk+NvaFJdnw/wkPKY
         egQRXcemCqrwc/7timPy3p4fSQGKc00q9dqo22zfgbB4JDsCxyvOvmzyDbMdOleYs7d4
         AOcsdGC53BxdC+OUwgVA65jqFjT5f/OkW3cZYaES8rsW6FiNh6YINL4RK0ZxR9iYNDCb
         BIUT0LH/wNjuOinfc5jXk4WzI4oVY2tGMFnVSFpHPDzDC2kWZHlg5PhcvfPxY4RPUwKB
         +V6A==
X-Forwarded-Encrypted: i=1; AJvYcCUqbYVpF6G39YT2hr8q9sXE6kcKRq/MdhGkXJOLP06WZTiDPV3q9Kg3iXP7p6g+Kh3/JRvtlvh3h6v3mq9ZHw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0gq558XjSp3rY/WqOyW2iP8QDXEmZFtK0WD4Haw1GId/UM/JU
	X4pYA1Avq062M1F18v+jS0rSoPpTbGCsXxZWrffoHMrCe636oxIUbt8U0vCt2MC3ITIuXkB4Rtv
	oQ/sn3SZuRpDKYHHji35vJEe0YgB86gITGAqUU3hwjg==
X-Gm-Gg: ASbGnctwPpeIi3HWjgoyQ3S9WyqmCfwxJjEP7DQ0Ro8Wk607P/vXYCXHRtpsOYBqgi3
	i+f6sNa6hUZDDK8WEbvF0VEyDjUOksp2kDxro4MR3oEZSHebOxzKoq81eoyrufan/iT1i4Kgrrm
	Z266Z/Dado6BxdsV0xDuJ14SZ1W/Fbr3/b8OcYAoqGU3yYBfjlRc7Z4Y1v0I/YQz+Ha5PxaHqAt
	Lm0DOA+E9r8gJbdywRhnU3AwcNn52h0xrRYXaia
X-Google-Smtp-Source: AGHT+IFgCUrOgKDXyTj7GZPbtBGdfLjCb3Cogmef8NZ3q9DnRJcUl4hBGQ5M8P4T/CAyyaWU2Gl1rIxBQFBTfREpwE8=
X-Received: by 2002:a05:651c:1117:10b0:336:cf86:d405 with SMTP id
 38308e7fff4ca-33bb00c67dcmr27527941fa.18.1757412721551; Tue, 09 Sep 2025
 03:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905085625.97367-1-marco.crivellari@suse.com>
 <20250905085625.97367-2-marco.crivellari@suse.com> <n7ktycej5ipkjem7hdf6bqsz3srawduxdstxe5du3gybwrm5gz@wdd3ipeyxn7a>
In-Reply-To: <n7ktycej5ipkjem7hdf6bqsz3srawduxdstxe5du3gybwrm5gz@wdd3ipeyxn7a>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Tue, 9 Sep 2025 12:11:49 +0200
X-Gm-Features: Ac12FXxIGUvjtajBOd1EV4WHH__xO4CN7wJNct_nnLPT70RCboiwCvfhIMXNols
Message-ID: <CAAofZF7bssWkmP3pv7XPEzPr2qEy=jwowzt_8gVB3QfeeESdrg@mail.gmail.com>
Subject: Re: [PATCH 1/1] closure: replace use of system_wq with system_percpu_wq
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 6, 2025 at 8:54=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> I was confused until I realized you're updating a comment.
>
> Acked-by: Kent Overstreet <kent.overstreet@linux.dev>

Hello Kent,

Yes, sorry for the confusion.

Thanks!

--

Marco Crivellari

L3 Support Engineer, Technology & Product

marco.crivellari@suse.com
