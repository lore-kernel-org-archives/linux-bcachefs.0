Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013FE39FCE
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 04:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724561304; cv=none; b=lbDYggI7CuBh/BuHZlgmqwZTWLbqTDsExV55IMeVWdOINsHoJTc4HP/fzgn/lJnFK3KsdWpbx7EEOEI1lbmR4ErZDUeWXMpFiTYqsQ2QCFo65bR5XTsL6Hv186qShyY3x+C5trJHfldgwCKTFcmtT34ySbIo0ySPZhBPUVnq3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724561304; c=relaxed/simple;
	bh=qlJbK3xIdyqcPgYOGsIATmRpnretQ+wygPFBlCC4sVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JmqF/zg2LJT2aZtcQyjq5x3nqxeVgWkDqY2J0Hw2X9DaC/QnTVtQ0Athrj+ZBYX7rc/chSiAuY7U3gajRwQTieVBP0EQl3EUg/4z3Z3/wYu5f0GyV8eJSpAqAZP+pAUiw9k0CILzSY+uqIESyW+3GKnt9jZbClCTIfjYII8/Ktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hcTIPJPw; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hcTIPJPw"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-533488ffb03so4084166e87.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 21:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724561300; x=1725166100; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Prad/u1Mm/FIa7fZYDRAzWsz5EsLmPEuCx1JJ5KClZg=;
        b=hcTIPJPwjqy2TX2Mcv0gQ3VTm4JV9RipiO3p7YGa71Kq5UeXzPNy/zEjSXxKl9PIu6
         aQ1l/0hcCsUfx78/EWQa/kOlElMNroQDSiGlCkXkVK/CQoPogMVzVDA+zpoBAAkOSV3E
         8y3+87H8h7dkucg9jVGEQuWbMVPneLGGYAmNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724561300; x=1725166100;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Prad/u1Mm/FIa7fZYDRAzWsz5EsLmPEuCx1JJ5KClZg=;
        b=SFZIMeaXd6kZl0amhFVYwf8jkj9tDyy+NTzmkEAl0kqpTVgiCQ4yFn4A1oRB4yd2lt
         I7Jft0FMGcIpsqBshWpBfnyHq/ic5HnWMjdxiLIFpJIy7GWolejJM9JDpnEFkvjzK7cw
         XrIPcFY49eL68Kl/t4kEFmBGxQrsiCvoZspQMb/KcOTf7Q4CZipv3gZUeqvp2NaYcAGL
         q9cU9ug8/dh3WCyc7sIEfUtc+fjXHmKMCMrkd/KgGnoMZrYeWcR3G5UYGQ8V03RpGYIO
         nMzUdJ6nWzoLlMUIZE4j8nSYhGkq4zw0kYs+SSe9NK++/fQGGhLbD7+cQ5qH6HxYZFB+
         ejCw==
X-Gm-Message-State: AOJu0YwryF3ImfCaPY7Ggugze18wdHcG+UZzMPJXg5rdEPKiR0dRkQqM
	vM82H6qjHWyqgwcd52I7saAGmQfgCN64Sc+9yqGGNx4yfjcIDITlZYCUvX35FkNmGob6fIHEJP+
	HppaYNg==
X-Google-Smtp-Source: AGHT+IG6tnd0adYSEsbIcRq5EKFU865yVffmKmMH/QRPspqV+BuHuq2GgSGIp+bqHhClwCkpCYGhqw==
X-Received: by 2002:a05:6512:3ca6:b0:530:aa3e:f3c with SMTP id 2adb3069b0e04-53438832e83mr4873824e87.14.1724561299246;
        Sat, 24 Aug 2024 21:48:19 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5334ea3611asm1033616e87.64.2024.08.24.21.48.18
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Aug 2024 21:48:18 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f3eabcd293so39421291fa.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 21:48:18 -0700 (PDT)
X-Received: by 2002:a2e:9d4a:0:b0:2f1:a7f8:810f with SMTP id
 38308e7fff4ca-2f4f5799390mr38042051fa.36.1724561297627; Sat, 24 Aug 2024
 21:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c> <hmtzlfu6t5shnt557pykpjha3nnkx4sqa3qaqfzx5rh5kcdusp@jr6mtee5pwq7>
In-Reply-To: <hmtzlfu6t5shnt557pykpjha3nnkx4sqa3qaqfzx5rh5kcdusp@jr6mtee5pwq7>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Aug 2024 16:48:00 +1200
X-Gmail-Original-Message-ID: <CAHk-=wi6_6BDpPdsH03Wkq6sn_9QxxamC2rz7e7OYH1W1Wvnew@mail.gmail.com>
Message-ID: <CAHk-=wi6_6BDpPdsH03Wkq6sn_9QxxamC2rz7e7OYH1W1Wvnew@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 25 Aug 2024 at 13:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> ok, I take it you don't like this one either

I'm on the road, so I haven't had time to look at it yet.

              Linus
