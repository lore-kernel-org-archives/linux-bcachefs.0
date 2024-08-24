Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858915E97
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 02:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724467255; cv=none; b=EIgaRscYo4D6M2hrtBG4r3d+tp79LSPuF8ghQRn0Q6KPlzRjrNyEbuS87GlEd0jmXAdtOitmLBs4ywqU+9YqZf96nHwsdr2BZZ7slbGpw7baEnTcqG24pFeBIN3EnCNvROZB8j7YJZl4yOx5oRaXCAhAIhoWubyIvcn0j0dR5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724467255; c=relaxed/simple;
	bh=Azva8laTZ/2BkvfzyODM+ZKSQYox1Eu/+5PSMYsEbtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWrgbnPkR4eNUy/80bnCxl5Nf2FHhijgmtPYQBe3ca6e9b8BXxaown4N/2Cezcfzj3nfnCUa7rRYHuL7i/JffrwBGyymz6gDbmFBHJAnUTF7Epvh3G1o5jT73FlIKYhFN3nHO5WSPMC1Kda9RjD94BfuTSd2YbhX/ngrqP18/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hcb3fMlO; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hcb3fMlO"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a869332c2c2so378583466b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724467251; x=1725072051; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g+tZBKZfR9xLINW1ciKZzSilx+udfG+brXdL2+OvlBY=;
        b=Hcb3fMlOSN78loNkIAmehRWUHWwjNVuCGkN2bvgfSxYvByJI+lqqiydE0P2PJhbmgx
         xJa0dnoEmIMGREDsR/0IiLy6yCOfkxhrLOZW2mnNFFLb2t+efZvnE3RFRE6XVm1q2GSL
         L5scbiMVtMARuHUGXelLYIjVcfMgXJuKa6h08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724467251; x=1725072051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+tZBKZfR9xLINW1ciKZzSilx+udfG+brXdL2+OvlBY=;
        b=m7buAKOHAzOGwNGPHshh/79iTFFeBSH46ctMwmm5FSQgxPc1D1ooSGR2TQK6IFoQ4L
         APkbGvo+Dq17tbEz3gxVOxcBllFMb4O6T7kjUDkKJuu7561xFdfu44J7frnFoT/sCEno
         DHWiGtHPPjbIhNpZjgfwl/uCLnlDm/S2KJNVLHMvmco9O3LyeMVRrRHq094nSNNlB2U8
         Y/7OvX+VdNr8GLMGV+OTyNdKzlyRk/0SMXfPlYrjNbx7NteXJymX/uB6i6wlWtCvG0wa
         fM0mzH+yCAQAeBvELicVwIyeEUTPBle5WPgAuMXQWQV3YI229CJGD2q7n2I47fUAlw6K
         M6IA==
X-Gm-Message-State: AOJu0YxYk0qcWZFe4QnZYH0n0dbw48wQW03pxJme0k0RdGUYHRUSJimM
	12Q5KZz/fqfhbHc9p2/P5/BqyKQbLU9Y6h+LnTbCU8oTv+zoJZwO2BoVZUQg/l6aCQTM/qJuaev
	O2/jAfg==
X-Google-Smtp-Source: AGHT+IGQw4eyZpPg4luQJjvFMIq1s+hff/zkK7I+oQi9vjAPSZRa9qzdqOGHkGtrkaV8xaGVohj4KQ==
X-Received: by 2002:a17:907:843:b0:a86:4322:eba7 with SMTP id a640c23a62f3a-a868a928891mr920379066b.33.1724467250982;
        Fri, 23 Aug 2024 19:40:50 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f2e66eesm339830666b.97.2024.08.23.19.40.50
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 19:40:50 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bebd3b7c22so5898814a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:40:50 -0700 (PDT)
X-Received: by 2002:a05:6402:26d3:b0:5be:fc0b:9a6b with SMTP id
 4fb4d7f45d1cf-5bf2bfd55f4mr9202951a12.5.1724467249913; Fri, 23 Aug 2024
 19:40:49 -0700 (PDT)
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
 <nxyp62x2ruommzyebdwincu26kmi7opqq53hbdv53hgqa7zsvp@dcveluxhuxsd> <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
In-Reply-To: <CAHk-=wgpb0UPYYSe6or8_NHKQD+VooTxpfgSpHwKydhm3GkS0A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Aug 2024 10:40:33 +0800
X-Gmail-Original-Message-ID: <CAHk-=wghvQQyWKg50XL1LRxc+mg25mSTypGNrRsX3ptm+aKF3w@mail.gmail.com>
Message-ID: <CAHk-=wghvQQyWKg50XL1LRxc+mg25mSTypGNrRsX3ptm+aKF3w@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Aug 2024 at 10:35, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> What is to be gained by having release rules and a stable development
> environment? I wonder.

But seriously - thinking that "I changed a thousand lines, there's no
way that introduces new bugs" is the kind of thinking that I DO NOT
WANT TO HEAR from a maintainer.

What planet ARE you from? Stop being obtuse.

           Linus
