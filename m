Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97181474C6
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 13:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718371465; cv=none; b=EwA4NYBxFkaaLd/KuDATgyl23dNzcRpoucSHbCM8977o1XDOpw0jmNQLU4R4+UojbDs+YqV6iac3QH+HELlWSHPRDsEaPIM1TikfhWrORqcsXIgWxAsx7+6ew0nBexZBVNnAg8pz8LmrWqjtqGLfn5GsYmo6IEo81S4J/Sk8OiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718371465; c=relaxed/simple;
	bh=zD2HX9Z/cYM56zTCmJKCKii1qWx4gfK4UdglL314bL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oiGouMNAtH8kMKrMen7DlTCApBvOLfBZRPyDy7dVeoFbZFwl8yjvfvLC3oM8kJNWW9w2r+d9fDBPFsAS/JCcsoYENsDpshd/gkQwrUu2R6odktIHg92ZADqFBfZmhhlL9mQbLzrHoO3zX6u6ddvsvmwHrOp/dYFagPvxmjD/UiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGQTLpNj; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGQTLpNj"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52bc121fb1eso2689569e87.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 06:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718371462; x=1718976262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1soSqPSQajpbLtai850fWW/qzPCEQEDJjaa9C++4mQ=;
        b=nGQTLpNj7EpggRTr69fR5k4PVQEFXTqI2VX8mRt96fxUpt0RIQRHNGXW8HQX+XTlDD
         C4s6xP6HDfN0H4BHcBhMMwlG1kZBNAZTxyJpkcp3Oi646ub21aun2/cOqfYRAqyY7BFV
         rXq+G/zncx5HSLr/xRFnpt4bd1Ve39JOyasDgcubYv33/yqEu+LoG5bvovlmRcQgVTjz
         VYDhN1FeimDOlNDWxP069W1NRBgPN9evBNt9i0HpUwOAMl7NIbDB42SwR/Aon2EPuRV7
         467Ycohw5O6xVkoLcygwEsoyXAWcIhD9NshM4kP8WVhQNTHeqANLtGpERg668AJnBOnK
         17LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718371462; x=1718976262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1soSqPSQajpbLtai850fWW/qzPCEQEDJjaa9C++4mQ=;
        b=gr4kq9ip5jVUGvVijxORxYyKsFPm8x+SQAQm9gGpDe7N+VXOzhlU6cMj3WHFE5mUb3
         Qg3cLQbIZ2wrzeUBE+Iu3Gc7xrZ82zzNITtHolJkyHhgJCpS00tTIxt3XCAqgr5XHGIY
         myqkZLj8IT5fePiHRNp9VYlA5PIATeSpQIxZtnPI5HsbVV0fWHXtOMihgQ5BHHGLoUFB
         zttvGhIsgdaJ8YbmCYYPYe0g3MjSW963U3tH1RdBphWSN/cvwmq7LKcYIX38VPf4qmlD
         8/yS+E7vgqvkG32DE00sk/nnkE6gPrqwNnzqhjV0CXcjufOeRwsWlhiRuNkm9LjP2orz
         kSHA==
X-Gm-Message-State: AOJu0YwQS73otCk215V3LMqsfb6dqaMiM3Gw0+YykC4EhfOZjIYW7hRH
	LZLKAsUEkXSemF+y7GvLpNM263yom1B4PRxNwVTP7LSu5hNR0EcbVlEuge7jkJPfti8ITVR2C0E
	d1uxWrIAOG0PMUBZ8/ecXRZ51ky0skCCa
X-Google-Smtp-Source: AGHT+IFZch0gpjZjpi3Jd07Lz6DS9dAzUfMU+Mexz1CTXowd7OLegndNxGLiDxDnsDaalLabfgrZK83yNEo5tCVaqss=
X-Received: by 2002:ac2:546b:0:b0:52b:de5b:1b30 with SMTP id
 2adb3069b0e04-52ca6e90bbcmr1352895e87.44.1718371461752; Fri, 14 Jun 2024
 06:24:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604074325.798349-1-ariel.miculas@gmail.com> <4ewvaxk6vfogqymbcqiagt6mzcqgq4vbnyjhbfcuoord5ln7q5@skpnxdtsksct>
In-Reply-To: <4ewvaxk6vfogqymbcqiagt6mzcqgq4vbnyjhbfcuoord5ln7q5@skpnxdtsksct>
From: Ariel Miculas <ariel.miculas@gmail.com>
Date: Fri, 14 Jun 2024 16:24:10 +0300
Message-ID: <CAPDJoNsfiH9db4O1G3=L6n3aA2avL5zt3b_6_UFsT3yqiVXdMA@mail.gmail.com>
Subject: Re: [PATCH 1/4] bcachefs: allow initializing a bcachefs filesystem
 from a source directory
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 9:40=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Tue, Jun 04, 2024 at 10:43:22AM +0300, Ariel Miculas wrote:
> > Add a new source command line argument which specifies the directory
> > tree that will be copied onto the newly formatted bcachefs filesystem.
> >
> > This commit also fixes an issue in copy_link where uninitialized data i=
s
> > copied into the symlink because of a round_up of the buffer size.
> >
> > Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
> > ---
> > +enum COPY_TYPE {
> > +     COPY,
> > +     MIGRATE
> > +};
>
> enums need to be namespaced in C, do
>
> enum bch_migrate_type {
>         BCH_MIGRATE_copy,
>         BCH_MIGRATE_migrate,
> };
>
> this follows existing bcachefs conventions; if we do an enum-to-str
> table later we don't have to deal with renaming the enum or silly
> uppercased names in to_text() functions
>
> Other than that looks good - if you can do that as a fixup patch I'll go
> ahead and apply the series.

I can do a fixup patch or send a v2 patch series, which option do you
prefer?
>
> Thanks!
