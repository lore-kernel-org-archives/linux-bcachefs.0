Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C584B383B8
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705874776; cv=none; b=SDHn2JzjTf6uaIsvwAoMVyiEO+TP6rGoHQ6RJw7PPK9np11xzT/2j7fEHbXFzlK97RMwr+/tAWtkc5KP0dXwpCnh9JYbhl7IM2m183H9Z0J/LiVvyR+NDFTN5Xqn/lPiRvEGeKJMMgct+R6VDnrlz/cQ8s/NajwIaoQt7cjxT+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705874776; c=relaxed/simple;
	bh=eKWkdKMEDARbLDRUqfnzbi3sl/rOE8242LOsXnrFZJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kcD0xb1fANdZxDX5DpIkgYFCMcq2PaOjQ2Bce95PIY9EwsssDd0zP6knxtGXLa1F76DUeDubEd/Fv4QV/kqiNP/sqPr5bCWQVYZYOl0aOhnwiH7om0QkPWtG0cmSYUE9KirrvbfXD+2cX94TjzJP6OHOwmCRGahLnwvP9qQWDfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GnUqPOHA; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GnUqPOHA"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50eabfac2b7so3015506e87.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 14:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705874772; x=1706479572; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QlVOU0qgbHsfmWmBhtAfMlGMpRk/E6kiXNX1BeiPg/E=;
        b=GnUqPOHACOv4PYToAApEQmo36jT+KsCI++EXCNa7Ki9UF8Ww/dpcOFMpcu2Yv5jhTj
         yoFIKH+UxChATRuCgiX1FFeMSxEoDxNh56tqfH4X176HSyQOhZaZ9uDvkmS+oINfwMb3
         En3gIaOBDci0BdUHoaEzTA1J+OfSnDd/FUPIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705874772; x=1706479572;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QlVOU0qgbHsfmWmBhtAfMlGMpRk/E6kiXNX1BeiPg/E=;
        b=oVVIoDJSt640c7Defjgr3fagd//3PDp/AlAPGpVgJp9B0J3wLW7kANl9KW3xjWkQHX
         KDjBMPJNV8dXZR8YcZ378Cn6v2fV3n0SukE0V1yp2ry2G4G6Ng7OjOycJg5Y50bR6usF
         qAF4Gl/9rfcR7cmTM/OtPkc5ty6oMME5/SOtE3Gyuch7kLTeB5vSNnWiNi9Btwi7ijmR
         S8Nhi6Xc3B9vZPlxq5ZMMu9kjbWBwB2YPeOyLQ79/s50XOk2EjxqiTgOFWKYzVR7QC10
         l7vBRa2Csg3TdtntUncByVaDo+u/OQzSaUPwhz4hL234anHn2PQFYQ5X7Y5g8baDq95s
         6mGQ==
X-Gm-Message-State: AOJu0YwI8QpgCos01VpNKreVltIsv4sEWgQN7JM2eeGUZcQOFxwf5wh9
	r42YWJFWqCkxOH0gwECaNBRVorWeqIuFrIkIKWJEXDupd3tvTgVgu2l0beIxnKzcfWcy8wwghyN
	eOcgKdg==
X-Google-Smtp-Source: AGHT+IHm5JAVd3xwP4hOe9p+KL4e3cLqGv1yAtIf6ueSb7+GC3cyMe8UW4bXyEjxVFO4sdc5qJ+LPA==
X-Received: by 2002:a05:6512:33cf:b0:50e:7e53:8f6b with SMTP id d15-20020a05651233cf00b0050e7e538f6bmr1261773lfg.127.1705874772544;
        Sun, 21 Jan 2024 14:06:12 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id wb9-20020a170907d50900b00a2fe4463711sm1725349ejc.0.2024.01.21.14.06.11
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 14:06:12 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-55a44bb66d3so2694010a12.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 14:06:11 -0800 (PST)
X-Received: by 2002:a05:6402:1a2f:b0:55a:6d67:6319 with SMTP id
 be15-20020a0564021a2f00b0055a6d676319mr1539223edb.54.1705874771698; Sun, 21
 Jan 2024 14:06:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a34bqdrz33jw26a5px4ul3eid5zudgaxavc2xqoftk2tywgi5w@ghgoiavnkhtd>
In-Reply-To: <a34bqdrz33jw26a5px4ul3eid5zudgaxavc2xqoftk2tywgi5w@ghgoiavnkhtd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Jan 2024 14:05:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjKjvytH19t2mMHZbkY2bpGurGbG4Tb7xmTjfzA71Lb7g@mail.gmail.com>
Message-ID: <CAHk-=wjKjvytH19t2mMHZbkY2bpGurGbG4Tb7xmTjfzA71Lb7g@mail.gmail.com>
Subject: Re: [GIT PULL] More bcachefs updates for 6.8-rc1
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jan 2024 at 13:35, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Hi Linus, another small bcachefs pull. Some fixes, Some refactoring,
> some minor features.

I'm taking this, but only because bcachefs is new.

You need to be aware that the merge window is for *merging*. Not for
new development.

And almost all of the code here is new development.

What you send during the merge window is stuff that should all have
been ready *before* the merge window opened, not whatever random
changes you made during it.

Now, fixes happen any time, but for that argument to work they need to
be real fixes. Not "reorganize the code to make things easier to fix"
with the fix being something small on top of a big change.

                Linus
