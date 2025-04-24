Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E441E1DE7
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Apr 2025 06:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476027; cv=none; b=kTsc3r/SX0st74UZKoaCup6mFMJrl+WhE8SF+B9c19PAMqpp2NTErINPol60hmwKA4r6uaGFHuTLLLg9kbmiJBMNlso4xd1kMsNpeL8/1JiOt6iDtsXyJK5Kz377YKxRbPBv9TvYuOO3nZcQOU3H7+f0TjvXz+EA2T5y6lXGkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476027; c=relaxed/simple;
	bh=1CEUNaxsGYi+QBHFI7XRuBkvQhG1Q2jnC2EGOCsAxeU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tUaK837ouu+7Xoh/cBKnMMytFYcWzEbofZa2BrcHQmmOm5wuMngCYUxxk6t4236ni7t/Pj4JUMo9D2aPTMW6vTQzkrEJwHx5mSSl0/6lR+DqZwQgwUSkJzL+RZxA7xl9eQe8n749qLEVDGP+E/9jKKgCObsvj7CS60CNihfTyJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d81bc9b763so10738685ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Apr 2025 23:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745476025; x=1746080825;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=abwTUHeE/uM/GG3wbgxZgYH14k44x/XKVziJanaRMJQ=;
        b=i5jVtl5AASfDdtpqy2NyVfr83wN9R1lkyrQhorfXVKxAYjA5SgWE/6732yqXGeCvZn
         3JvZjjeoCd3oF4CiRciLL86QG5hLjxBtwT3TxXqCf2NB8bamHkIuKqv9akLMfU57KV+y
         PQ5p6YEkCw9beGfGTgEqMnEkxGgtUTDCGZPQBfSsRCCwiUfgJ/FWPNBizfKPuGRv9+gz
         hIeHU6PdjfG3vPr0gbDK+ftlpGtgGNhsSRUF0+5GB1frA3yQSU1upbbo8WwlNirkwOG3
         oOQMX1u1CzEfTNGSTCPUVoTKNNoNnQWqH140F3ORo9eaqOeleAY2NU8eKFXJgn3qOaxh
         1v3Q==
X-Forwarded-Encrypted: i=1; AJvYcCX32sIMmCA/VqFjG70hdb+dQ9EP4Ng8hGlpfATnRbncSJnTspTFWHk/N1mbncVbSCdPPInLThSRWn29k4mL7A==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr7w/Gl0yy8Vs5OUFBif23VV/mUD5LK3iJA6FV/X7v08Tv2cb/
	uwe9JjpLqE/G825TudQeH9chTP/gnbt4/JqtHlHkq3mVDyCDRfaP7aAz2E8O8SXgouE/aZUd1u/
	swNWSNMAxj6ciqFoLyFecuLAhWOX0Hp42+FJgUzdEY13yXqgIzDysQfE=
X-Google-Smtp-Source: AGHT+IFAG+7LNAPZtc1E5WJPuIr/o5oInRFOA+A/8lLUB47/WjeWDwH0OueyKOJzZl0O1FTB1Y/2Re9FjK7IGhotHKn+KtxGYm/U
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c3:b0:3d3:f7ed:c903 with SMTP id
 e9e14a558f8ab-3d930234869mr14493155ab.0.1745476024913; Wed, 23 Apr 2025
 23:27:04 -0700 (PDT)
Date: Wed, 23 Apr 2025 23:27:04 -0700
In-Reply-To: <67f76c11.050a0220.258fea.0029.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6809d9b8.050a0220.2c0118.0ac6.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_str_hash_check_key
From: syzbot <syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com>
To: contact@arnaud-lcm.com, joshua@froggi.es, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d37c14ac6f05ec98db9b3d9db424dc73a0f5b1cd
Author: Joshua Ashton <joshua@froggi.es>
Date:   Sun Aug 13 17:34:17 2023 +0000

    bcachefs: bcachefs_metadata_version_casefolding

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10718ecc580000
start commit:   a79be02bba5c Fix mis-uses of 'cc-option' for warning disab..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12718ecc580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14718ecc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bbffc3b5b4301e1
dashboard link: https://syzkaller.appspot.com/bug?extid=843981bb836d699c07d1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f8c1b3980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177ce574580000

Reported-by: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com
Fixes: d37c14ac6f05 ("bcachefs: bcachefs_metadata_version_casefolding")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
