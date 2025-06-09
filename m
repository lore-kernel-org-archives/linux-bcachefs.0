Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956122A81E
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Jun 2025 03:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749438664; cv=none; b=Afc+57UAJeq5BiIiX9vspjBdY0NUek7+AXurTUWcikF0Z1126HS5IL9hHw8qp0n2bulTBBYDCgvgN9qlTj42VL/YzejfCSbsH3QAwqVKQMv+ZSbBs1JaySk/XqqzGorEwl0HQlr9xenoUIIoDiYL0o8b/LD6lAOjLtMj86p1m5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749438664; c=relaxed/simple;
	bh=XqX8W0WXjmvJmcTYPtm3CDkoRO35HGBnjqGMJwyZerM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SZdXywH9jQMrgG43xy0fYSk6zzjsLaikce/mI+9ixrmFHIUVoWW+QxkUe2bxC+TVYYY47bSAB3g07gYi1HR51AjXqCu0F0H0saiUmyszVuhqwqf9QDksd2gzDDhlscr/W5U+RejpA0o+oBDSD0WoLlaNtp92GJJbyxMM+l3FvTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87313ccba79so590415339f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 08 Jun 2025 20:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749438662; x=1750043462;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wo7UpV8gmOqqjSSyDcx4sdLxk2Thz6qXIr6g3frrVp8=;
        b=H7RY2JWU/yafKajg7Q2v3/bTl8SXTaR15TQACTef9ObAxt6RfwcX38hiinVfwcfJkM
         hSojQ673DrdCTOwF33EKRZBgRwYVd0GdGgiJBw7plyxWxD1STXz4PYZXXLLofl0rQccb
         dKdlImf62YEn/GPXOGWVXnue3znPhkMEsF0+LERnk4gRHeLabSAlbEG6PFqnNVh38IaG
         7I0qZyersB+XGVViq+JzFETuqq1gICSxqXLo3JKiRl7iiFdVh770eh0a9l2e3C8HWf7J
         3tE8kiejqxnPNRxEbPdfwZW6QGdKso+w31u0bWBf6TgFHkF94JXtfcJkcwnpG8Ce1Ae7
         MGLA==
X-Forwarded-Encrypted: i=1; AJvYcCXsg0SOvIVAmIfXNo1M0OQhODwz4iGdf20SS/EpkM7jOSOBDbnTBhx0c/RcG3fV0mNd2H6Ns5CdqYm4ozxbNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOaRgc5I95Lo0RQUtzqCiSr7NQNULMVb8EcARWpB056qWb2MNE
	8C3eM/EDKaLFdf/30x4/fqMOz9p8lTSvZqweeV56Emgf6V97FrBS8Hs879ynSWxXG8nuioNmCkw
	rigq313eyPgFonc6NloAcDL5fE96kaJkuLJhkem0CB4mdvMlBvbhqZYU/Jbo=
X-Google-Smtp-Source: AGHT+IEpUfLTrGAb9S5XjnQfzSLe9AUGAJcv3mfxO7vTH7UhO3BuyGZJcFzIEYx7ZuJlkvXzjBZ3b7JZGRRDDZiZx0cs0Ss6h8uI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:188a:b0:3dd:b7da:5256 with SMTP id
 e9e14a558f8ab-3ddce48b1efmr123961825ab.19.1749438662672; Sun, 08 Jun 2025
 20:11:02 -0700 (PDT)
Date: Sun, 08 Jun 2025 20:11:02 -0700
In-Reply-To: <6745a8df.050a0220.1286eb.0015.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684650c6.050a0220.d8705.0018.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] general protection fault in kernfs_dop_revalidate
From: syzbot <syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com>
To: bfoster@redhat.com, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17abb20c580000
start commit:   28eb75e178d3 Merge tag 'drm-next-2024-11-21' of https://gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=146bb20c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=106bb20c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=402159daa216c89d
dashboard link: https://syzkaller.appspot.com/bug?extid=e37a1730d63d207fe403
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163706e8580000

Reported-by: syzbot+e37a1730d63d207fe403@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
