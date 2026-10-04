Received: from mail-pz2-f36.google.com (mail-pz2-f36.google.com [74.125.228.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A887C23EA8B
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Oct 2026 08:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791103679; cv=none; b=koFYtNmeC0QXiD1SgSaricc689SgMb91rLzV3piJw4m4/DILBN0h5KJWLWz6eQH2mOZMNz7TMJIxA3fv6qoMF8tghWl285UfC7VKvnItDqdi6kiM2OwiNBmcPzftRUr/W+qQr7VjqlTHAlox+Z3zStFJJzdfYHmijV3Bgq5Be+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791103679; c=relaxed/simple;
	bh=yGtHweDtXARW9ZBhSGOmesmT2UIldU/E8mS9qx7kG3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2MfgNb4iv3u4YX9m0yzcdbTdHHB0+VQ+dwBs5tjuYZ6Sb57KYpeDLjklPazw09uEHuKygRcrrP+Z0LA//m66gLJdRWM0DYPcWuG5PWrLOzVRlgHfY6sD2gY7aMBY+l7+sKnjzix6S63Q4P0tXTqpV8jCBw1WZPQNUfkbC1jy9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORJlMoJk; arc=none smtp.client-ip=74.125.228.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORJlMoJk"
Received: by mail-pz2-f36.google.com with SMTP id d2e1a72fcca58-88a0f29ce98so280016b3a.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 04 Oct 2026 01:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791103678; x=1791708478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gHcli4wZjkXbSdyMRve/F6lBR5WyoYsRUZns8w19MiU=;
        b=ORJlMoJk1HFM/nEdAvZ8LHPlE/9ZgEEnz72VrEYT9lOZC8++RGBH/W9SC/dnp35SI/
         2J4iZ+21Q0LA+YTiXH1uK762rnyz5OEeZnJoqoWhAIJ57KYkRBMCmh1zmbKKl9/BHOaP
         Y4swiXIYVULy//z+0QppS59mXlsWgwFgW3VlgQbiaVmqkYgot8hvnXdpF7ZPxYdH+Z/L
         LNevaSJvOsDfkFUYJBu2yR56u5v7GIRw98TxGmfB/2Wk+6uSZ2Iq2gsuBE96wIAm3xUw
         yzyWAQeBevBMsmnotit0I0pekcF6PYgoGVMHuDlq6tJkYbEVbrhOHw31stBoO+4c/TAf
         K7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791103678; x=1791708478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gHcli4wZjkXbSdyMRve/F6lBR5WyoYsRUZns8w19MiU=;
        b=KtdoDZ3rIkeYMTy/gv/z+ScFRBg9i4bT+ClriWCWCY7eO7lGsPp9co3BroxX0cEd36
         W1UfSbTLpyxd65Al46L6CzcNqm3UJpEqZ+3FErmMHxM0oz/6E0MuK3k+/9O755BCwoCf
         UyAYa6TQMcU7o1IpDjQgKNeOx6ysvksZqCPGnDeirTuGv/c1ecIRMVItiDdiVU4r962c
         K5DVTpBVb0SdFGNfoiTW/x/8JHbuMTI4kfobFx7dLsvwjpuOz1f7uEXRg/5R9y+HmUeZ
         ketzk0YaZJIfzOGqotqKyDJGLg93jtwcU6P4HDYZ8AcYj11VxTpM0OAD6lmNcwP60zD4
         apag==
X-Gm-Message-State: AFuF++m4w3TPbtridYFzUktKeY4igf8CbvSUILEorrzO3+lxJc+8obhe
	LIpHzNNcO0YOwJj0RjA1oM1QqWbhQNZuaKz+roca0oiEzIOfMvrK4OvOQ7HB+qluzLI=
X-Gm-Gg: AYBFou2SWazWoNFaXCMTSYkBCdaRULRLW85hoK6ZcdPWQyxBAqRLJtPD+SReaqQRFNM
	4VodWMASyxofohCIhThw1gEB3sMnd99peeLURFxvPfp6hh8VQLFqK5XyIOM8Fr4cSVE9iJPhj72
	f36b13vHnCqB2hoDS/BtnNe6Yz9GIfHlCz4oCA/19b9gPwDNytDk58Zvq1/8bJ8x4re7ExrYzvT
	65QaR1UEf6bmcEGNsQGcYqmoHa094c8P9jf0qdWgrTcBu9i+F5Um67RvHrZAl0tAXDEqSpBj+KH
	IJgyvjRZcF/7lJz2FN7JThkxw3vMen0uoWajTl74aDizFk+W58jv+5JYiFVfz0tDgERC9PWZQhP
	nVqUQyEjAWH5QyNRucwUXgw22daEWxk4txX32OZUC9rZ86d1LdogUi30amVc/AjGdi39w7jHU6q
	XAT9Z/iHL3puJv8h8nV04kZe35AJIr+SFgipUN53Y7HIwvDgl4rO2CfPGsybiwq6HWa1m8PARoM
	fw5wAt6JV9bqNgRnh0870J5R3dYqR63v3QEiV/Kvw+Ks/CvwdoAX6n26CY3mXbHk6BJoK9/a1zC
	35/dtKGyg6kpLkaEgIE/ZmfUpoowmDNMlDlhM/K/Ld8UAZhmZvIK7ks6l5yR
X-Received: by 2002:a05:6a00:451b:b0:881:e737:8213 with SMTP id d2e1a72fcca58-88af2494d70mr7238754b3a.7.1791103677809;
        Sun, 04 Oct 2026 01:47:57 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b069b47b1sm2402950b3a.0.2026.10.04.01.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 01:47:56 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: J B <jb.1234abcd@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: dkms-bcachefs-build rust error on ArchLinux
Date: Sun,  4 Oct 2026 16:47:54 +0800
Message-ID: <20261004084754.39043-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261001154719.427562-1-matthias.goergens@gmail.com>
References: <CAJXMFhEt=9hGnYaFHDSPLZYk3BWRudxW0M=XTpiFuoH7vaz0-g@mail.gmail.com> <20261001154719.427562-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Arch has now rebuilt linux (7.2.8.arch1-2) and linux-lts (6.18.54-2)
with rust 1:1.99.0-1, which is also in [extra], so after a full
pacman -Syu the DKMS build should go through.  Please say if it still
fails.

Matthias
