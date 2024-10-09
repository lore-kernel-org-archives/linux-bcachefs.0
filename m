Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFED0199FB4
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728485627; cv=none; b=bb/DMZxUygXLPrsAKGsjXtEV0+OHs76ssKp7a+AfJ7XFhs/EAEaXuKCCSIdXrNo07+3kfwifkf2ncQoz+vMBQZrdAqGOl1Z3dWTexUAT31VO7N8YLXPWjOoiF5X9rTBG57wcdZZTfacEiefPHOyyzbkHaerJetAGpX3oZlaI5Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728485627; c=relaxed/simple;
	bh=crDl2NzXZgDGHx2v6vzbTeLJwmytF1ubvOwXxdE+NqA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cIlk/NPGhkQciMW5Q3YfRhN9TmUuVNNyjj1j/FoiJGNzuvr8o/PHuzkkR+TMwq2rM9bpUYLkXBkE/8MC/CJE78tXb1KhR9eJLnl4jmXaC6366lhlRrYCOBEHVKNmbhFdAh6S8GP6JG9OcrhGvV+xqPiq/5WUddKaXIiMIOFl1Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GL2hLynu; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GL2hLynu"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42e748f78d6so61977715e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Oct 2024 07:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728485624; x=1729090424; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5MtrD7oPz4t6W4+32cQ+6J1RqJ2Xvya6ZU3/5JUT5E=;
        b=GL2hLynukCkBCQeN0qqpVqBpKl2nahQYYNqFk4ASzTIGuHMmR0d01JYuCbCuyE6G7t
         iMgLtTdkzij1sdKYoPAjyc22cTrGyHih+DiFqUgNqH/NcGknyEwOz1wMdcJaQ0YTkuu2
         dnRu90IEjUDPLxgSwbh9zwb5HDKq+qwTxzCpM1GX685eU14JV2hWLLiHmjXe9qYu2Qoq
         4WhBTIIiHBfDv6AFraRcx/u/CJ9lwtF1gJAJ6oNb6GyrfTph0KWY4JN/tLvdD+PhBxHu
         RdvsbrfxmPmq2JQ+o2i+66AJQ1MiQr0XfsgBrH49BFaT0cP28eaYMpf7Ok2otlEmdNh2
         dfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728485624; x=1729090424;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5MtrD7oPz4t6W4+32cQ+6J1RqJ2Xvya6ZU3/5JUT5E=;
        b=ZDT1kKu9RgLSX1mn/6PcJciOgx7aGCYacdgtjS4LlXrjnl3Xk5R12z6AGH7E0A3Ucs
         1tGp2dlwKcsNHtPl56srsLTKhcKcgiTAwsgI3PDCrGFeB4zbXLAlw7EMkJcRQdbY6lJ8
         YvY0i3NOSyCHI3cDPl8oI+v8eYSjJak1SBhCRk9dtnfSRcBWdDrBBa7hSfxufDM2YDKu
         4nS8/GRw4ThjuFsoS3qSbBtsKMPCEcVOecAYZMMIKGAn7etHpYLU3d5I7MrVuZFtIJTl
         8NgMMJhoA03EjKmSVrCdmhgCWDX2Q9l0Cs0/hDIQRn0woPtFJE44o9ZZ4dsOGbigQEfm
         COvA==
X-Gm-Message-State: AOJu0YwlmAlw9+HaDtBn56ytoIX9i1KUkprU7blUdE9CI4I6XpFu+l0+
	ywNQhJL0LLdJ6aCApO48rxo5nOZy8bI/+3W/u8QoDMy3m8QBLZs72W5igVb1gHcqXhM5YznR82Y
	I
X-Google-Smtp-Source: AGHT+IEYcm+nuogvd7NRkZlCnR1GJo/gq/TAwDl7uMQS/dD5uyX+QsytSr/zGN6G2HJcpvsz0WGZjg==
X-Received: by 2002:a05:600c:47d7:b0:431:12d0:746b with SMTP id 5b1f17b1804b1-43112d0755emr12129425e9.35.1728485624042;
        Wed, 09 Oct 2024 07:53:44 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d2e65d618sm3981355f8f.23.2024.10.09.07.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 07:53:43 -0700 (PDT)
Date: Wed, 9 Oct 2024 17:53:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs:
 bcachefs_metadata_version_inode_has_child_snapshots
Message-ID: <f18f39b9-cf61-46cf-9112-19dd59e36dfe@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

Commit 6375feaa7a3b ("bcachefs:
bcachefs_metadata_version_inode_has_child_snapshots") from Sep 29,
2024 (linux-next), leads to the following Smatch static checker
warning:

	fs/bcachefs/fsck.c:1183 check_inode()
	warn: should this be a bitwise negate mask?

fs/bcachefs/fsck.c
    1168 
    1169         ret = bch2_inode_has_child_snapshots(trans, k.k->p);
    1170         if (ret < 0)
    1171                 goto err;
    1172 
    1173         if (fsck_err_on(ret != !!(u.bi_flags & BCH_INODE_has_child_snapshot),
    1174                         trans, inode_has_child_snapshots_wrong,
    1175                         "inode has_child_snapshots flag wrong (should be %u)\n%s",
    1176                         ret,
    1177                         (printbuf_reset(&buf),
    1178                          bch2_inode_unpacked_to_text(&buf, &u),
    1179                          buf.buf))) {
    1180                 if (ret)
    1181                         u.bi_flags |= BCH_INODE_has_child_snapshot;
    1182                 else
--> 1183                         u.bi_flags &= !BCH_INODE_has_child_snapshot;

This was intended to be u.bi_flags &= ~BCH_INODE_has_child_snapshot otherwise
it's the same as "u.bi_flags = 0;"

    1184                 do_update = true;
    1185         }
    1186         ret = 0;
    1187 
    1188         if ((u.bi_flags & BCH_INODE_unlinked) &&

regards,
dan carpenter
