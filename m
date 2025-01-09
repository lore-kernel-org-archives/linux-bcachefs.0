Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A0921CA1E
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 Jan 2025 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736437204; cv=none; b=kiNM2AHIGbIHx98lpAMUgpJMm1tXc7MlHnTK+3dYxtOajuSRg9ugH+EEBA9563vgL3/nkAz2uo2GRUcKq8Ua3OaV9GAbBSLfE3xu3YUATTDC+SHCtDkwfcVxs6sEs85129iCPWVCabmQfZOPp7Dta1P4I4Y4mIJHq2ScqrWx1U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736437204; c=relaxed/simple;
	bh=a3Yv/+L324km3ROgztJ+Im9LrTyJXPDs5B9fwXcLQnc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dHSnb9Uedwd83eewhMhnGBHbl9vRIF+I4RSHKWFrpp6G7lrSMrhG6JfEQHu9vHtujz9FMBvQcnBBSuXQp9KNlgs1v0wD4Mu0WhsNd0mhmi58R0SQTAh9gYIdMZQM+mWRa4k5ajXv3tbhWs0q4LBjYMwlq2ipFv3FKBQ0qoTe5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a78c40fa96so7982285ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 Jan 2025 07:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736437202; x=1737042002;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0/OJqdhdo/8iDaYC0wOKw78bN9cKs6+28OowyPcTsv4=;
        b=XVvcLkZBZgb+eI+Xw4Ylh6ZpvvZHGJ1MVGOFgsoUu8I2cy1PbvCmhDdvkohqKkgY26
         GSRaYsp8ynpLQrQKstWLZu0vc6xRmPRytmLwM+OZqSHS6sxqE4NMFXx/oEHL1Hcro4+3
         uE2h30PlEP5FOnhBd9CfE5UgFHdxuE8XzAJSqIhgCgA5VCkkof2+ga4xWp01ItFKlem5
         D4DV0nlchElGoSZgln+aBefqjY3R3lJZKeg9CzrwKpzS8Rhkn5ozwRrwa1my9z048Tr5
         2GUMVZWpIQEO4wy1ycJs27cJvRFwJCLz/8AFfP2m5eSpOdMefyUqDSRvn8wSM3V8pK6k
         4hnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWia/iZxiUKAiYZ+Qz+ZJzekZjnbkBDkt9pDfR9hj7aGMAITd32u3wkENv8bsk+8Sja3IjDIcwkb2YTlNLJEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLeSc9bvnw1Bn3YU3WHLjwz4hLsZV94n+WN7Z+4wMErpFjlv5w
	JImKNvP5wknhIOgbBrlYdRnW2Aoxi/DTmtlqGvbSZRURwEi+yR7UobGRUR7eAELkoa1C+n0rLsm
	+Zh12AGKKAA3YVSzyH67q17oA6w3nYLjPZiIJNYYJU+1C7t+19XDIaqk=
X-Google-Smtp-Source: AGHT+IFXJfl1AFFROHLuG9O6YHloPXXAGBYCCUPw8FOnbaWMbo+a47Xg09NaJ7BqL2QhEHRvNrEqPXUr1imRM86kRU0o4OYOlxMP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdab:0:b0:3a7:c5b1:a55c with SMTP id
 e9e14a558f8ab-3ce3a8936efmr55126545ab.0.1736437202506; Thu, 09 Jan 2025
 07:40:02 -0800 (PST)
Date: Thu, 09 Jan 2025 07:40:02 -0800
In-Reply-To: <6744873b.050a0220.1286eb.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677fedd2.050a0220.25a300.01c4.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_exit
From: syzbot <syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d97de0d017cde0d442c3d144b4f969f43064cc0f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Aug 13 01:31:25 2024 +0000

    bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13432ef8580000
start commit:   8155b4ef3466 Add linux-next specific files for 20241220
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10c32ef8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17432ef8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c90bb7161a56c88
dashboard link: https://syzkaller.appspot.com/bug?extid=e733ab672a1b6724c27f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f5b418580000

Reported-by: syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
