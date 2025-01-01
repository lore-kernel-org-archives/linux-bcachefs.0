Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12031854
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735748706; cv=none; b=TnTD8YcB+43YS9wlFmtWOIkDugi9QkfSh/EnzuwnHATa65FLNYmWyVH3m2PujBGcyrVYi52k/NniAlqu2DQmaP5ARR3Zoefbz4RAeoGrM95vyVCEeQlQwOmkrhw0doxVE/8CRS/Ou8NShya+kuv7RPGmBmcF9dVMTrg3SDmoUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735748706; c=relaxed/simple;
	bh=7C4WSwye/vC9PLnjeeqHSafmgOeCuQs1UCbXR3DSTbY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=usAQYU14Kj6Rzj428kH6/TU4Gk5okRvzfnU04ntByUf1fSSyqO1HjU5QSLOsHKi8a3yVRClhhGKdGUt9Cqmf1kOsNEFQl8hbp/irlNK6VFh0/Kd/OLn749iWEtmlKNw3aeqgxFXwZbIZaty7DXj4WM8qrzLW+1mHCaRbhdtoVvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a9cd0b54c1so92533675ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 08:25:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735748704; x=1736353504;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TP0Kz47Gz8abEzisbY1uEacNkdoefoFyb1CFbH2hL0s=;
        b=SC5A5k0V3Co3mjonkEXKlOyh98wi/ABrb6n8z6X7FLc3T9bwfNYIWxzkDWkUT+pEXy
         8R2krDe4nye3mhsE3Y7vTpvRPorLOoMOr7O9CyL5V4pylDMqcIt+h5xUq33/+Jffct8n
         aFBm4NsLIvpkshfW7gQp/S584BmFY1veI7Nw18s3prn1JF0kvU+OHX1XfC4mQ1GxQDVS
         48KuvAjdYg77ekEHMm0DFIfHm++GFECf9QEWLTIAoKKEAr9aGnYI+5Rr1nnH7GXb2K41
         C4LuiezCYVCUZRk7kMHojvX4+dYxaSRTgRul+02uwCCaSR7Qlbq1H3HqtWKeCYYnK3mY
         SufA==
X-Forwarded-Encrypted: i=1; AJvYcCVVlMSFCd4e8vZsZB/tsNcLjUZKb0/CiiKbMoZxEOm0+5Gtfe0bLQSWMz3cTpc24x3Jq5KT1gmp09itYqKSCA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrZWiLPxfClCxJk2P7Xmq874adscpT+JhO7DuFNcIigBpfs2Pf
	A2RE+iQaT7V8ZwGNe/CCABrfjUXTD6OrHQgDNY2zoNmJe8DArS33xn6ZUM9P58AK60ZhTyXlO7J
	iOPby/d8h0dcl2yb9C3Nv+YTVJr25ZcxIdE15RzgHrxhAWU7DlL9QHnM=
X-Google-Smtp-Source: AGHT+IFOq6M4beTWJ9NknUQYDlCaQmq36E78XYSNHMALOhlecX6rmftR/hi/rZi8vci+V2m+MGnXKO8cThEvh3r9seJ0XXbK7bGg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2c:b0:3a7:e286:a572 with SMTP id
 e9e14a558f8ab-3c2d14d19d2mr386095255ab.3.1735748703787; Wed, 01 Jan 2025
 08:25:03 -0800 (PST)
Date: Wed, 01 Jan 2025 08:25:03 -0800
In-Reply-To: <66fd2663.050a0220.f28ec.0510.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67756c5f.050a0220.25abdd.0a14.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in __btree_node_pinned
From: syzbot <syzbot+9f41e4b255897d99d4e9@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, niharchaithanya@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 7a51608d0125469664e2daf8e060d6d783924c98
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Sep 5 00:49:37 2024 +0000

    bcachefs: Rework btree node pinning

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=115c06c4580000
start commit:   ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=135c06c4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=155c06c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=9f41e4b255897d99d4e9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118c28b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d45af8580000

Reported-by: syzbot+9f41e4b255897d99d4e9@syzkaller.appspotmail.com
Fixes: 7a51608d0125 ("bcachefs: Rework btree node pinning")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
