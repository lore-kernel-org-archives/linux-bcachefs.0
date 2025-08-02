Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F7118D
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Aug 2025 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754129055; cv=none; b=fp/BFL5JlWM0hbj1lwWL73MvkMyztEllJa5HR3jsJxllqkHf2K6MK3DR9+EOarcVdIjexxY/tXtsWwOwccU9gdqZ2X7QRaAa0J0+ef3GOoy8hleAkkm9gtAExEW2qOtURnMYXJa8P/rHxJfchdKl5zC2t40s3v9fLYcyIcGAKSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754129055; c=relaxed/simple;
	bh=97gAxnh0fEMkcSwI4B4lfP7CM4ztyMA8z9xfL7ubip4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=dxcs5SjnGiPHVCvZJypJ918uVl+o9/lUWkBj/hKrKQgE1rZ0kKvlxhVTaZZWMd9LuNcbXJAoWox3vtfoPMDKDvb0U6/5czAuIwNdIYTLsd0jyIPdARj7Pl8af0Qk1B/424VwhMnkO9JRL0D+pqoDVW6ExJHMyED+wiD7xgO2Dzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PnDQmli3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PnDQmli3"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5725exxP030050
	for <linux-bcachefs@vger.kernel.org>; Sat, 2 Aug 2025 10:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=pUrhfkypASB9H8lKbshbus
	xBoT4k5NSrZrJajYeWNFo=; b=PnDQmli3LwNpRGOGd3NvuYgjDQrQgosnWqJ/hx
	M6m9Su44/kyiKTkSMWI4lqv91zceHOoYZXE3T/sdpFWarrcFCV31HomIgcYWhYl6
	E50TahhTUatqDxoIFfKaT0ETLXnWYuuVsfG3d2K2b5yE/b6Gh9i8yM+ymLDNROHb
	6mJy9yEZutDtCQXHlsH9tDiTmAutxarBR8Z1UW+1L6WIS7KEh+xBJi4Fq5JaNxnO
	FhfWeQJrZoARL6xo8Iv+fu+lfQy0hIY/bWYKjHGdQ5g9M6cYkEWsvQJhkSrlGHen
	+kkTOSbXBV1fSlgX8y7zRjEC1njoJ1vCHNxAUNW8lDlnFrrg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 489arwgmhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-bcachefs@vger.kernel.org>; Sat, 02 Aug 2025 10:04:12 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-70941c8a17aso1432436d6.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 02 Aug 2025 03:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754129052; x=1754733852;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pUrhfkypASB9H8lKbshbusxBoT4k5NSrZrJajYeWNFo=;
        b=NxaIxfh25Y6+2I9okeAQfEfEztoFE9SMeLWhmzZxylP2gTmcxjRyR9xf8jCco+pV08
         FmKdfQRSw6o0cTles6ULZ7bUYlv6RVvpd38YcYXtFu6feGPa3DVw+B9XvfpUaa9Q4Zb8
         1ci5D5C+QpTsmVBx9kLW9KMolPIoHVrHr/4TOMXbUdualXCjdVALB2DV4EBVUJpwx6Dn
         P8QDGA+tW07aRj5+8KP+O/iBrWT0mcQt4bDmH9msYCKN4ncamEIlmpaqo+bsO1XXJorP
         MLE8GouoC4n/J1oI7AVdKPdieFFEplIOokF2y2fCXJ6VZL5bPZ/c7Soz699FDsmNL06A
         2FYw==
X-Forwarded-Encrypted: i=1; AJvYcCXtQdMcDflpsMlHatppnyOOpHQJ4YrW+zglvMwBcvh9B3c6v9jGif3RU+XjYgrbsQ8zOLsOGV6mG9g714PC7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCcvNpC9YYXlqrQhcU5RxLzHxYe/d0P/DP5fhpwN2OgW299iSO
	FFV3rRgJOA477DtxxQf3l3JopelOlylSvObw3giOcXTzlBJV+TnMX5kGKGFoeMcMNTgcMlr8OKh
	p4NM+061ywryg1PbvAwSIQMO5GBHrjYxE8thDa8RYv7ZbPIiIbQiW83YoWCSMjZYkcHw2uoVySD
	sp2w==
X-Gm-Gg: ASbGncv6LV8dF6uIRc6JvLY0CyQDtQDofptRm7woL12T4b2kc1K53Q5ygTKp3amQZW6
	pfRDlnMFARp2k9IXsJx47lDXPR1/DFiYwdylQUuBSTEY98PofdDlgzLBG9pwV3cwKPeBDa9pVNH
	Pdilt+wh0wpiPPjR9D/6qz4HZ9APIYjwaWukQU+ZeoBLlEPQMPSNEihFhPanf5YT48dH+gSnjkK
	i7GJjTxK5bUz9xYUgNH0pmp+q04y+2EvOC74XQxpoIsCu4U8KW+ywNLNk4T14Dzp0b+n9tkiyOG
	DlZO6OwcdOjJtNPMtdFANlCAnAEVXVVndp2Y3prKQjjaN+nh/usUZoIImnoPJ+jbUs9BSp0/z6Q
	7M5A5n/XrkYJteoSUAw==
X-Received: by 2002:a05:622a:d0:b0:4ab:635b:a309 with SMTP id d75a77b69052e-4af107717c5mr22217531cf.0.1754129051686;
        Sat, 02 Aug 2025 03:04:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqqD5eyppq8LAAIBy/fBO2svh5Knc9MSxVl3Cia3qlBiWJudW4SR+015MJCk+gdRzxv8sYPw==
X-Received: by 2002:a05:622a:d0:b0:4ab:635b:a309 with SMTP id d75a77b69052e-4af107717c5mr22217341cf.0.1754129051173;
        Sat, 02 Aug 2025 03:04:11 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f2a448sm4003043a12.20.2025.08.02.03.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Aug 2025 03:04:09 -0700 (PDT)
Message-ID: <b390beb2-441f-4a3d-b53d-3f554b308be2@oss.qualcomm.com>
Date: Sat, 2 Aug 2025 12:04:07 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Build failure on next-20250801
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAyMDA3OSBTYWx0ZWRfX34qI68khw7Co
 R8UYU4zGO6MLFo6NvjPBus5ZxJG929XWwIJIpR1szWS36pCTHCRTwOpSKb0YRRcnuOlfxk5wn6T
 QpMSbLKa2TZvAWnZTtL+fGyHdPc3OQKccqxG2GeKeEixD6vQA/glm7d+Z9ghpDsEIUr0zEib9nB
 XjWai22R0U3j9b6VAAr9hi+Ak+RAutM0ZnWVLAgyuhSEUaabK41Rwzz0HNzRb793ZNNSFEc+W9J
 Kcm3R+mjRcVo34WHgTGO4hN/a5y0C7yVrPrUMkXelkKs98WVPkz8zIK4atD7R6UYLeMWkuJ/75m
 v1M78ZnOUrPZt8Usi2A/YbdYf0oRxIXweFUUc05paPP9Bj6NinxorVS5hvxCYMfBVVUvANNbjwf
 E9xQSVkG7jOvi6Vxc7OT7y24ijX8r5s5CDsRhkc1A7xLAcsVbjhuZ+cTRWVG48ikL3jN2nZG
X-Authority-Analysis: v=2.4 cv=We8Ma1hX c=1 sm=1 tr=0 ts=688de29c cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=ljw3QelReVnGxZt3u5EA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: hNEmyCcdALZBERtzInL830QPvOeNoo40
X-Proofpoint-ORIG-GUID: hNEmyCcdALZBERtzInL830QPvOeNoo40
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_08,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 clxscore=1011 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508020079

Hi, just hit the below on next-20250801

Reverting

4c3205637f1e ("bcachefs: CLASS(btree_iter)")
...
69c862491582 ("Revert "bcachefs: Convert bch2_bkey_get_mut() to
CLASS(btree_iter)"")

(mostly as dependencies for clean reverts)

gets it to build again.


In case that matters (which I believe it doesn't), I'm using clang
on x86, version 20.1.8


fs/bcachefs/backpointers.c:391:7: error: cannot jump from this goto statement to its label
  391 |                 if (fsck_err(trans, backpointer_to_missing_device,
      |                     ^
fs/bcachefs/error.h:140:2: note: expanded from macro 'fsck_err'
  140 |         __fsck_err(c, FSCK_CAN_FIX|FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
      |         ^
fs/bcachefs/error.h:117:26: note: expanded from macro '__fsck_err'
  117 | #define __fsck_err(...)         fsck_err_wrap(bch2_fsck_err(__VA_ARGS__))
      |                                 ^
fs/bcachefs/error.h:111:3: note: expanded from macro 'fsck_err_wrap'
  111 |                 goto fsck_err;                                          \
      |                 ^
fs/bcachefs/backpointers.c:398:20: note: jump bypasses initialization of variable with __attribute__((cleanup))
  398 |         CLASS(btree_iter, alloc_iter)(trans, BTREE_ID_alloc, bucket, 0);
      |                           ^
1 error generated.
make[4]: *** [scripts/Makefile.build:287: fs/bcachefs/backpointers.o] Błąd 1
make[4]: *** Oczekiwanie na niezakończone zadania....
fs/bcachefs/alloc_background.c:2097:7: error: cannot jump from this goto statement to its label
 2097 |                 if (fsck_err(trans, lru_entry_to_invalid_bucket,
      |                     ^
fs/bcachefs/error.h:140:2: note: expanded from macro 'fsck_err'
  140 |         __fsck_err(c, FSCK_CAN_FIX|FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
      |         ^
fs/bcachefs/error.h:117:26: note: expanded from macro '__fsck_err'
  117 | #define __fsck_err(...)         fsck_err_wrap(bch2_fsck_err(__VA_ARGS__))
      |                                 ^
fs/bcachefs/error.h:111:3: note: expanded from macro 'fsck_err_wrap'
  111 |                 goto fsck_err;                                          \
      |                 ^
fs/bcachefs/alloc_background.c:2107:20: note: jump bypasses initialization of variable with __attribute__((cleanup))
 2107 |         CLASS(btree_iter, alloc_iter)(trans, BTREE_ID_alloc, bucket, BTREE_ITER_cached);
      |                           ^
1 error generated.


Konrad
