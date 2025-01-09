Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53474203706
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 Jan 2025 07:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736407071; cv=none; b=Lpm4YDclyxtzDRFvTTKzAuRFF7wiamZ9JEgxbG2s7l3RFXXTGte+eGHj0N75QFZZrLXFARHa/lmSaaPRTaVIWPC12CvzV9edYfnPC2GKcMxFS6ccFU1tzC9TuRkRs/dOPhRcchZdW4CjkjGb87+xZeTllnSDO5kw3dz5CFVE0RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736407071; c=relaxed/simple;
	bh=OAWVYytWbZdk5jZeEHqA6pWEx215bSx0bkeF2awx8rI=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=NR9RTj+GHr+cuJnhKOo4EYzOi5GGtuktbn8/S2zDUvaoh2Yw9OdjG2JV3OmrK2FOAPFyjRSQVcXgG3bSd0W0qgXzjhK1P4mureY1O1dg/ahtviNHfBzjddKM+Jp3RGoVVWY2jDMCQk53S3/O2XFTm9oggHSCKSfjyKz28qtXv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1fV89cC; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1fV89cC"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-216401de828so8126745ad.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 08 Jan 2025 23:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736407069; x=1737011869; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OAWVYytWbZdk5jZeEHqA6pWEx215bSx0bkeF2awx8rI=;
        b=B1fV89cCXttlMRGzqD3c/+U9wA3IEphzaEoLAztKYN74NHVdJFCWj04fUZPzTDbrsj
         mtj5jwJc0IWe3QaWsywZHSfcz28GBlO6ZYid/rmfSbVVHDttJGx20ORfwhXMASZzQpak
         3UoFug7mSI7JS4MBQJRRMvQO/gtOjJIkgGP87GL20FOtnwCIG7M8yLE9y5cZQVapqKHd
         dKF3GfxkVsdO2kpb41N0a8xevl0Mqv/ZEn3fjz7Sknj6WJeWdH7aZX4UZaBaUD7y578G
         kSAuLLI0n4TcNtzC0W8gMWl8JgI7jeErvPeiP74umVOcHehcCHfZC8uJxkRBa8U0/E2k
         5oxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736407069; x=1737011869;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAWVYytWbZdk5jZeEHqA6pWEx215bSx0bkeF2awx8rI=;
        b=C/iNPERbvM8WIqV3f68HDP8hYWzd3BrWycecc8NauY0ZXR0vtGAVu1Xv0BS21S2EV9
         lscyWOtpWEuYiBbSYc4ZxqjNlsN1sZ4/EhfZTklBmHdXa2fng2ZaalCK7kqXb/qcNDtJ
         wUkV1l8DIRHu2oYFXSv3kT3/NUX9E+tR4n/lBnwqv4rEMqj1O5oxo0ba5oQ4vpdAzkBo
         EKYCvqR9ojvt5jLjL8v/AqHZvU4nqfzUfscXiSpRPNF1D8ZwKdug2o6f3fMd3f1e6kWS
         PnpIbBQq0y+0+FiKNVptq2xqRw3zDURCUinMiq2jubR+A0L3zx3DXAii0UcWKFdXL23T
         Gacg==
X-Gm-Message-State: AOJu0YwQKVRaFvyrHWm5hR79ftaP36PUFgzOUU8yr0DbN/Hnm/oRy7vB
	fiAXQWvV+qrqOYPWmIfqfAw7djReryFqphv3QaeXsGX1T7CNOF5Cy+ywz/Bn
X-Gm-Gg: ASbGncsEYCzKDzZXpU8bfa0CWXFtSn3o0aFayVoHcXttBxcBlXIcGAtBEfRo0ZH9cyD
	/T67EIhJD6usJZT5M3fECMyw6Kn6Z6VJnnAamFEZbvJK4vl/92TBbRv2fc2lTLkapHM/vupdKc2
	/yIzb4Dcv8OBlHmG5Sqsfv/HQUwSIrYkvNifqnMUMpZawnjGO9aMSOz+N3OzqY1taJ70qO0576J
	PDPG0zYISgJe5JTUl2DP34JMAOTTjt0U62n+iG5
X-Google-Smtp-Source: AGHT+IHvg4LTXECNPkENrnxP4ZUXbOe4C28JSd0ObKC4u9wfdi14REbQ2QtCvxwMlZN9Am/2/hqZTQ==
X-Received: by 2002:a17:902:b285:b0:216:7ee9:2235 with SMTP id d9443c01a7336-21a83fe49e2mr80097285ad.43.1736407069528;
        Wed, 08 Jan 2025 23:17:49 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02b77sm339369535ad.242.2025.01.08.23.17.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2025 23:17:49 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: The missing patches
Message-Id: <99F79FA0-61D0-4E27-85E5-3D8ADC676D63@gmail.com>
Date: Thu, 9 Jan 2025 15:17:34 +0800
Cc: linux-bcachefs@vger.kernel.org
To: kent.overstreet@linux.dev
X-Mailer: Apple Mail (2.3826.300.87.4.3)

Hello Kent,

Here are the links to the missed patches, I=E2=80=99d like to know if =
these patches are still needed :)

[1] =
https://lore.kernel.org/all/20240925164500.1178107-1-mmpgouride@gmail.com/=
T/

[2] =
https://lore.kernel.org/all/20240925164602.1179117-1-mmpgouride@gmail.com/=
T/

[3] =
https://www.mail-archive.com/linux-bcachefs@vger.kernel.org/msg02925.html

[4] =
https://lore.kernel.org/all/B0F9A8E3-F19D-4660-881F-14C40D740910@gmail.com=
/T/


Thanks,
Alan=
