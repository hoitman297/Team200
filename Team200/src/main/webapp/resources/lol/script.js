
        

//룬 정보 js
const imgBase = "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/";
        const shardBase = "https://ddragon.leagueoflegends.com/cdn/img/perk-images/StatMods/";

        const runeData = {
            Precision: {
                name: "정밀", color: "#d4af37", img: "7201_Precision.png",
                keystones: [
                    { name: "집중 공격", img: "Precision/PressTheAttack/PressTheAttack.png", desc: "적 챔피언에게 평타 3회 시 약점 노출 및 추가 피해." },
                    { name: "치명적 속도", img: "Precision/LethalTempo/LethalTempoTemp.png", desc: "공격 시 공격 속도 증가 및 사거리 증가." },
                    { name: "정복자", img: "Precision/Conqueror/Conqueror.png", desc: "공격 시 적응형 능력치 중첩 및 최대 중첩 시 회복." }
                ],
                rows: [
                    [{ name: "과다치유", img: "Precision/Overheal.png", desc: "회복 초과분 보호막" }, { name: "승전보", img: "Precision/Triumph.png", desc: "처치 시 회복+골드" }, { name: "침착", img: "Precision/PresenceOfMind/PresenceOfMind.png", desc: "마나/기력 재생 증가" }],
                    [{ name: "전설: 민첩함", img: "Precision/LegendAlacrity/LegendAlacrity.png", desc: "공속 증가" }, { name: "전설: 가속", img: "Precision/LegendHaste/LegendHaste.png", desc: "스킬 가속 증가" }, { name: "전설: 핏빛 길", img: "Precision/LegendBloodline/LegendBloodline.png", desc: "생명력 흡수 증가" }],
                    [{ name: "최후의 일격", img: "Precision/CoupDeGrace/CoupDeGrace.png", desc: "낮은 체력 적 처단" }, { name: "체력차 극복", img: "Precision/CutDown/CutDown.png", desc: "탱커 상대 추가 피해" }, { name: "최후의 저항", img: "Precision/LastStand/LastStand.png", desc: "내 체력 낮을 때 강화" }]
                ]
            },
            Domination: {
                name: "지배", color: "#e21d24", img: "7200_Domination.png",
                keystones: [
                    { name: "감전", img: "Domination/Electrocute/Electrocute.png", desc: "3초 내 3회 공격 시 적응형 피해." },
                    { name: "어둠의 수확", img: "Domination/DarkHarvest/DarkHarvest.png", desc: "낮은 체력 적 공격 시 영혼 수확 및 피해 강화." },
                    { name: "칼날비", img: "Domination/HailOfBlades/HailOfBlades.png", desc: "전투 시작 시 첫 3회 공속 대폭 증가." }
                ],
                rows: [
                    [{ name: "비열한 한 방", img: "Domination/CheapShot/CheapShot.png", desc: "이동 방해 적 추가 피해" }, { name: "피의 맛", img: "Domination/TasteOfBlood/GreenTerror_TasteOfBlood.png", desc: "적 공격 시 체력 회복" }, { name: "돌발 일격", img: "Domination/SuddenImpact/SuddenImpact.png", desc: "이동기 사용 후 관통력 증가" }],
                    [{ name: "좀비 와드", img: "Domination/ZombieWard/ZombieWard.png", desc: "와드 파괴 시 생성" }, { name: "유령 포로", img: "Domination/GhostPoro/GhostPoro.png", desc: "시야 밝히는 포로 생성" }, { name: "사냥의 증표", img: "Domination/EyeballCollection/EyeballCollection.png", desc: "처치 시 적응형 능력치" }],
                    [{ name: "보물 사냥꾼", img: "Domination/TreasureHunter/TreasureHunter.png", desc: "처치 시 추가 골드" }, { name: "영리한 사냥꾼", img: "Domination/IngeniousHunter/IngeniousHunter.png", desc: "아이템 가속 증가" }, { name: "궁극의 사냥꾼", img: "Domination/UltimateHunter/UltimateHunter.png", desc: "궁극기 쿨감" }]
                ]
            },
            Sorcery: {
                name: "마법", color: "#6c71ef", img: "7202_Sorcery.png",
                keystones: [
                    { name: "콩콩이 소환", img: "Sorcery/SummonAery/SummonAery.png", desc: "공격 시 피해 또는 아군 보호막." },
                    { name: "신비로운 유성", img: "Sorcery/ArcaneComet/ArcaneComet.png", desc: "스킬 적중 시 해당 위치 유성 투하." },
                    { name: "난입", img: "Sorcery/PhaseRush/PhaseRush.png", desc: "3회 공격 시 이동 속도 대폭 증가." }
                ],
                rows: [
                    [{ name: "무효화 구체", img: "Sorcery/NullifyingOrb/Pokeshield.png", desc: "마법 보호막 생성" }, { name: "마나순환 팔찌", img: "Sorcery/ManaflowBand/ManaflowBand.png", desc: "최대 마나 증가" }, { name: "빛의 망토", img: "Sorcery/NimbusCloak/6361.png", desc: "스펠 사용 시 이속" }],
                    [{ name: "깨달음", img: "Sorcery/Transcendence/Transcendence.png", desc: "레벨별 쿨감" }, { name: "절대 집중", img: "Sorcery/AbsoluteFocus/AbsoluteFocus.png", desc: "체력 높을 때 피해 증가" }, { name: "기민함", img: "Sorcery/Celerity/CelerityTemp.png", desc: "이속 효과 강화" }],
                    [{ name: "주문 작열", img: "Sorcery/Scorch/Scorch.png", desc: "스킬 적중 시 화상" }, { name: "물 위를 걷는 자", img: "Sorcery/Waterwalking/Waterwalking.png", desc: "강에서 전투력 상승" }, { name: "폭풍의 결집", img: "Sorcery/GatheringStorm/GatheringStorm.png", desc: "시간 경과 시 능력치" }]
                ]
            },
            Resolve: {
                name: "결의", color: "#a1d294", img: "7204_Resolve.png",
                keystones: [
                    { name: "착취의 손아귀", img: "Resolve/GraspOfTheUndying/GraspOfTheUndying.png", desc: "4초마다 평타 시 체력 비례 피해+회복." },
                    { name: "여진", img: "Resolve/VeteranAftershock/VeteranAftershock.png", desc: "CC기 적중 시 방어력 상승 후 폭발 피해." },
                    { name: "수호자", img: "Resolve/Guardian/Guardian.png", desc: "근처 아군 보호 시 보호막 생성." }
                ],
                rows: [
                    [{ name: "철거", img: "Resolve/Demolish/Demolish.png", desc: "포탑 근처 충전 공격" }, { name: "생명의 샘", img: "Resolve/FontOfLife/FontOfLife.png", desc: "이동 방해 적 공격 시 아군 회복" }, { name: "보호막 강타", img: "Resolve/MirrorShell/MirrorShell.png", desc: "보호막 있을 때 평타 강화" }],
                    [{ name: "사전 준비", img: "Resolve/Conditioning/Conditioning.png", desc: "12분 후 방/마저 상승" }, { name: "재생의 바람", img: "Resolve/SecondWind/SecondWind.png", desc: "피해 입은 후 회복" }, { name: "뼈 방패", img: "Resolve/BonePlating/BonePlating.png", desc: "연속 피해 감소" }],
                    [{ name: "과잉성장", img: "Resolve/Overgrowth/Overgrowth.png", desc: "미니언 처치 시 체력 증가" }, { name: "소생", img: "Resolve/Revitalize/Revitalize.png", desc: "회복/보호막 효과 강화" }, { name: "불굴의 의지", img: "Resolve/Unflinching/Unflinching.png", desc: "강인함 및 둔화 저항" }]
                ]
            },
            Inspiration: {
                name: "영감", color: "#48b4be", img: "7203_Whimsy.png",
                keystones: [
                    { name: "빙결 강화", img: "Inspiration/GlacialAugment/GlacialAugment.png", desc: "CC기 시 지면 얼려 둔화 및 피해 감소." },
                    { name: "선제공격", img: "Inspiration/FirstStrike/FirstStrike.png", desc: "먼저 공격 시 추가 피해 및 골드 획득." },
                    { name: "봉인 풀린 주문서", img: "Inspiration/UnsealedSpellbook/UnsealedSpellbook.png", desc: "전투 중 소환사 주문 교체 가능." }
                ],
                rows: [
                    [{ name: "마법공학 점멸기", img: "Inspiration/HextechFlashtraption/HextechFlashtraption.png", desc: "점멸 쿨 중 대체기" }, { name: "마법의 신발", img: "Inspiration/MagicalFootwear/MagicalFootwear.png", desc: "12분 공짜 신발" }, { name: "완벽한 타이밍", img: "Inspiration/PerfectTiming/PerfectTiming.png", desc: "공짜 초시계" }],
                    [{ name: "외상", img: "Inspiration/FuturesMarket/FuturesMarket.png", desc: "아이템 외상 구매" }, { name: "미니언 해체분석기", img: "Inspiration/MinionDematerializer/MinionDematerializer.png", desc: "미니언 즉시 처치" }, { name: "비스킷 배달", img: "Inspiration/MasterKey/MasterKey.png", desc: "체력/마나 회복 템" }],
                    [{ name: "우주적 통찰력", img: "Inspiration/CosmicInsight/CosmicInsight.png", desc: "스펠/템 가속" }, { name: "쾌속 접근", img: "Inspiration/ApproachVelocity/ApproachVelocity.png", desc: "CC 적에게 이동 시 이속" }, { name: "시간 왜곡 물약", img: "Inspiration/TimeWarpTonic/TimeWarpTonic.png", desc: "물약 즉시 회복" }]
                ]
            }
        };

        const statShards = [
            [{ name: "적응형 능력치", desc: "+9 능력치", img: "StatModsAdaptiveForceIcon.png" }, { name: "공격 속도", desc: "+10% 공속", img: "StatModsAttackSpeedIcon.png" }, { name: "스킬 가속", desc: "+8 가속", img: "StatModsCDRPercent.png" }],
            [{ name: "적응형 능력치", desc: "+9 능력치", img: "StatModsAdaptiveForceIcon.png" }, { name: "방어력", desc: "+6 방어", img: "StatModsArmorIcon.png" }, { name: "마법 저항력", desc: "+8 마저", img: "StatModsMagicResIcon.png" }],
            [{ name: "체력", desc: "+15~140 체력", img: "StatModsHealthPlusIcon.png" }, { name: "방어력", desc: "+6 방어", img: "StatModsArmorIcon.png" }, { name: "마법 저항력", desc: "+8 마저", img: "StatModsMagicResIcon.png" }]
        ];

        let currentPrimary = "Precision";
        let currentSecondary = "Inspiration";

        function updateDesc(name, desc) {
            const nameEl = document.getElementById('desc-name') || document.getElementById('detail-name');
            const textEl = document.getElementById('desc-text') || document.getElementById('detail-desc');
            if (nameEl) nameEl.innerText = name;
            if (textEl) textEl.innerText = desc;
        }

        function renderPrimary() {
            const container = document.getElementById('primary-slots-container');
            if (!container) return;
            const data = runeData[currentPrimary];
            container.innerHTML = "";

            const titleEl = document.getElementById('primary-path-name') || document.getElementById('main-title');
            if (titleEl) titleEl.innerText = `핵심 빌드: ${data.name}`;

            // 핵심 룬
            const kRow = document.createElement('div'); kRow.className = 'rune-row';
            data.keystones.forEach((r, i) => {
                const s = document.createElement('div'); s.className = `slot keystone ${i === 0 ? 'active' : ''}`;
                s.innerHTML = `<img src="${imgBase}${r.img}">`;
                s.onclick = () => { select(s); updateDesc(r.name, r.desc); };
                kRow.appendChild(s);
            });
            container.appendChild(kRow);

            // 일반 룬 rows
            data.rows.forEach(row => {
                const rDiv = document.createElement('div'); rDiv.className = 'rune-row';
                row.forEach((r) => {
                    const s = document.createElement('div'); s.className = `slot`;
                    s.innerHTML = `<img src="${imgBase}${r.img}">`;
                    s.onclick = () => { select(s); updateDesc(r.name, r.desc); };
                    rDiv.appendChild(s);
                });
                container.appendChild(rDiv);
            });
        }

        function renderSecondary() {
            const container = document.getElementById('secondary-slots-container');
            if (!container) return;
            const data = runeData[currentSecondary];
            container.innerHTML = "";
            data.rows.forEach(row => {
                const rDiv = document.createElement('div'); rDiv.className = 'rune-row';
                row.forEach((r) => {
                    const s = document.createElement('div'); s.className = `slot`;
                    s.innerHTML = `<img src="${imgBase}${r.img}">`;
                    s.onclick = () => { select(s); updateDesc(r.name, r.desc); };
                    rDiv.appendChild(s);
                });
                container.appendChild(rDiv);
            });
        }

        function renderShards() {
            const container = document.getElementById('stat-shards-container') || document.getElementById('shard-slots');
            if (!container) return;
            container.innerHTML = "";
            statShards.forEach(row => {
                const rDiv = document.createElement('div'); rDiv.className = 'rune-row';
                row.forEach((sh) => {
                    const s = document.createElement('div'); s.className = `shard-slot`;
                    s.innerHTML = `<img src="${shardBase}${sh.img}" style="width:70%; opacity:0.8;">`;
                    s.onclick = () => { select(s); updateDesc(sh.name, sh.desc); };
                    rDiv.appendChild(s);
                });
                container.appendChild(rDiv);
            });
        }

        function select(el) {
            el.parentElement.querySelectorAll('.slot, .shard-slot').forEach(s => s.classList.remove('active'));
            el.classList.add('active');
        }

        // 초기화 실행
        window.onload = () => {
            // 메인 경로 아이콘 이벤트 바인딩
            const pathIcons = document.querySelectorAll('.path-icon') || document.querySelectorAll('.path-btn');
            pathIcons.forEach(icon => {
                icon.onclick = () => {
                    pathIcons.forEach(i => i.classList.remove('active'));
                    icon.classList.add('active');
                    currentPrimary = icon.dataset.path || icon.dataset.id;
                    renderPrimary();
                    initSecondarySelector();
                };
            });

            renderPrimary();
            initSecondarySelector();
            renderSecondary();
            renderShards();
        };

        function initSecondarySelector() {
            const nav = document.getElementById('secondary-path-selector') || document.getElementById('sub-path-list');
            if (!nav) return;
            nav.innerHTML = "";
            Object.keys(runeData).forEach(key => {
                if (key === currentPrimary) return;
                const img = document.createElement('img');
                img.src = `${imgBase}${runeData[key].img}`;
                img.className = `sub-path-icon ${key === currentSecondary ? 'active' : ''}`;
                img.style.width = "30px"; img.style.cursor = "pointer"; img.style.margin = "0 5px";
                img.onclick = () => {
                    nav.querySelectorAll('img').forEach(i => { i.classList.remove('active'); i.style.opacity = "0.4"; });
                    img.classList.add('active');
                    img.style.opacity = "1";
                    currentSecondary = key;
                    renderSecondary();
                };
                nav.appendChild(img);
            });
        }