Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4C70839
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 04:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729916465; cv=none; b=qf7ZXYeOtuvaoY4MjVaqe2JE19dymHj4fwo4y837z2U/rLy2MMlLvM+mCMnbbfhYzrJgu9h/V5D9yV02A2nYrORAUSHK57BgLY8e23zOyLgHN+3o4dXlLZk0N9nehHfxagX4vPWH7ZwCa1DPLre6bnnVaWL/Ds80IJNJWKiwdY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729916465; c=relaxed/simple;
	bh=Pbyg2SCdQ2qqUtv04NFHNcaqxZ5kEH/SxyJuQT5T7SA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V0PEBuZzycvq6nha+jR030y/w8+I04AMS1POrTrUu8EhvpeINtXEWtnBeLknQ3pc4UAnzTgERxtrTN6ZDV2rqrsXiGZq0ZaGPqyNxFWMtPorvGqCuTbRTcxbvFksUyilgm3clUcys+57qTB/I8dEspzOuVLpb2WBye4k7JuXBH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c4554d29so25230905ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 21:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729916462; x=1730521262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3gcCkXBQQlWgRggAy8vJNsOKnItlW6M0FPDFncLohY=;
        b=GF9sEGIdk4RkSJiXoATETEr0yObnure/SJ5kcjBS37gEK+CS+Cp+wJFc7sdEGBToAT
         yq+CSuAbzidsCQgq6pvfdoh51tFzgFL7RvebOvrasmMWIlxh2QbaqwB3s7FT7vOHBhvO
         bvxYxyewK62A81MzUNBO6CTJy69SwJYMIrUGSn5AbhYjWCFm64ic3yKP042L3LKrQGYd
         G9JolJ7tDssJTenkqOoV3WoH8/uxV+pBRCAZXXzh0V+GYk96vFcHHt3pB3XhWd3uT9QH
         tflOmSYLgz1ehasFlR+8ESyQ+iDazVQojY577EUoBBI5M7PC2T7dJZj+LDSE6+In+p/o
         CsEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt+SzJdk9vSG4YksnykubMI3WreG5t6JoOPcAf4aUPIvZh6eodgX287wa+r9hQFn884E3rdk9y5y5rYKv95g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyROv4f6Zwl/QhUK+kZiXMAn+LaOR44rgthsXh96Gny0PFIq9dU
	ghUE59TquIlxiWZcjiJrqVpnnw3eLnWf5ofD3g6LY83OTB1ChqUB1w4wtl6WbtFLhuM9rPNkZ86
	H0D/gcfx4JMZ8yrEzCr3rQ3Nk+ZdcB7+ikQ3M49e0+L1U6DL2+G1hU8E=
X-Google-Smtp-Source: AGHT+IHNfk2Nkjjm8rK+t3UBrtBFHBbltaO6zrD43WQec1lExqtVuuFaRsw26OcSKwJNVSBrsXxO336iGvHoeskbdS6BcB+V2TA8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1886:b0:3a0:9f85:d74e with SMTP id
 e9e14a558f8ab-3a4ed2f6098mr12546265ab.16.1729916462673; Fri, 25 Oct 2024
 21:21:02 -0700 (PDT)
Date: Fri, 25 Oct 2024 21:21:02 -0700
In-Reply-To: <20241026041908.2739593-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671c6e2e.050a0220.2fdf0c.0220.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_reconstruct_alloc
From: syzbot <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lizhi.xu@windriver.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file fs/bcachefs/recovery.c
patch: **** unexpected end of file in patch



Tested on:

commit:         850925a8 Merge tag '9p-for-6.12-rc5' of https://github..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=c36416f1c54640c0
dashboard link: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11c57287980000

